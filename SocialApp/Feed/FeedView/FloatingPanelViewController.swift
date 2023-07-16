//
//  FloatingPanelViewController.swift
//  SocialApp
//
//  Created by Олеся on 22.06.2023.
//

import UIKit
import FloatingPanel

enum FloatingPanelState {
    case hidden
    case collapsed
    case full
}

protocol FloatingPanelContentProtocol: AnyObject {
    var contentScrollView: UIScrollView { get }
    var minHeight: CGFloat { get }
    var maxHeight: CGFloat { get }
}

class FloatingPanelViewController: UIViewController {
    private var panelState: FloatingPanelState = .hidden
    private let contentViewController: UIViewController & FloatingPanelContentProtocol
    private var panRecognizer: UIPanGestureRecognizer!

    private let floatingView = UIView() // for shadow
    private let contentView = UIView()
    private let disclosureImageView = UIImageView(image: UIImage(systemName: "heart"))
    private var bottomConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?

    private var isScrollDownDirection: Bool = true
    private var swipePreviousOffset: CGFloat = 0

    init(contentViewController: UIViewController & FloatingPanelContentProtocol) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var availableHeight: CGFloat = UIScreen.main.bounds.size.height - 40.0

    var panelHeight: CGFloat {
        return min(contentViewController.maxHeight, availableHeight)
    }

    private var additionalBottomInset: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        floatingView.backgroundColor = .white
        floatingView.layer.cornerRadius = 4
        floatingView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        floatingView.layer.masksToBounds = true
        view.addSubview(floatingView)

        view.setShadow(color: .black , radius: 10, offset: CGSize.zero, opacity: 0.2)
        view.layer.masksToBounds = false
        floatingView.addSubview(disclosureImageView)
        guard let disclosureImageViewSuperView = disclosureImageView.superview else { return }
        disclosureImageView.pinTop(to: disclosureImageViewSuperView, inset: 8)
        disclosureImageView.pinWidth(equalTo: 36)
        disclosureImageView.pinHeight(equalTo: 4)
        disclosureImageView.pinCenterX(to: disclosureImageViewSuperView)

        contentView.backgroundColor = .white
        floatingView.addSubview(contentView)
        contentView.addSubview(contentViewController.view)
        [
            contentViewController.view.pinTop(to: contentView.topAnchor),
            contentViewController.view.pinBottom(to: contentView.bottomAnchor),
            contentViewController.view.pinLeading(to: contentView.leadingAnchor),
            contentViewController.view.pinTrailing(to: contentView.trailingAnchor)
        ].forEach { $0.isActive = true }
        addChild(contentViewController)
        contentViewController.didMove(toParent: self)

        contentView.pinTop(to: disclosureImageView.bottomAnchor, inset: 8)
        guard let contentViewSuperview = contentView.superview else { return }
        contentView.pinTop(to: contentViewSuperview)
        contentView.pinLeading(to: contentViewSuperview)
        contentView.pinTrailing(to: contentViewSuperview)

        guard let floatingViewSuperView = floatingView.superview else { return }

        floatingView.pinTop(to: floatingViewSuperView)
        floatingView.pinBottom(to: floatingViewSuperView)
        floatingView.pinLeading(to: floatingViewSuperView)
        floatingView.pinTrailing(to: floatingViewSuperView)

        contentViewController.contentScrollView.panGestureRecognizer.addTarget(self, action: #selector(swipe(_:)))

        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(swipe(_:)))
        floatingView.addGestureRecognizer(panRecognizer)

        panelState = .full
    }

    func show(in viewController: UIViewController, placeholderView: UIView? = nil) {
        guard let parentView = placeholderView ?? viewController.view else { return }
        if viewController.tabBarController?.tabBar.isHidden == true {
            additionalBottomInset = viewController.view.safeAreaInsets.bottom
        }
        parentView.addSubview(view)

        guard let viewSuperView = view.superview else { return }
        view.pinLeading(to: viewSuperView).isActive = true
        view.pinTrailing(to: viewSuperView).isActive = true
        bottomConstraint = view.pinBottom(to: viewSuperView, inset: panelHeight - 10)
        bottomConstraint?.isActive = true
        heightConstraint = view.pinHeight(equalTo: panelHeight)
            heightConstraint?.isActive = true

        viewController.view.layoutIfNeeded()

        viewController.addChild(self)
        self.didMove(toParent: viewController)

        view.pinBottom(to: viewSuperView).isActive = true
        bottomConstraint?.isActive = false

        UIView.animate(withDuration: 0.3) {
            viewController.view.layoutIfNeeded()
        }
    }

    func hide(animated: Bool) {
        bottomConstraint?.isActive = true

        UIView.animate(withDuration: animated ? 0.3 : 0.0,
                       animations: { self.parent?.view.layoutIfNeeded() },
                       completion: { [weak self] _ in
            self?.view.removeFromSuperview()
            self?.willMove(toParent: nil)
            self?.removeFromParent()
        })
    }

    @objc
    private func swipe(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
            case .began:
                swipePreviousOffset = 0
            case .changed:
                let newOffset = recognizer.translation(in: floatingView).y
                let diff = newOffset - swipePreviousOffset
                if diff.isEqual(to: 0.0) { return }
                applyDiff(diff, fromRecognizer: recognizer)
                swipePreviousOffset = newOffset
            case .ended, .cancelled:
                //            if contentViewController.contentScrollView.contentOffset == CGPoint.zero {
                //                finishScroll()
                //            }
                //            finishScroll()
                swipePreviousOffset = 0
                if view.frame.height.isEqual(to: contentViewController.maxHeight) || view.frame.height.isEqual(to: contentViewController.minHeight) {
                    return
                }
                finishScroll()
            default:
                break
        }
    }

    private func applyDiff(_ diff: CGFloat, fromRecognizer recognizer: UIPanGestureRecognizer) {
        guard let superview = view.superview else { return }
        isScrollDownDirection = diff > 0

        // if we move down from content controller,
        // and content controller is not from start position - do nothing
        if recognizer == contentViewController.contentScrollView.panGestureRecognizer
            && isScrollDownDirection
            && !contentViewController.contentScrollView.contentSize.height.isEqual(to: 0.0)
            && contentViewController.contentScrollView.contentOffset.y >= 0 {
            return
        }

        switch panelState {
            case .full:
                if view.frame.origin.y == 40.0 &&
                    !isScrollDownDirection {
                    return
                }
                var newHeight = view.frame.height - diff
                // if height is larger than maxHeight, we should not do anything
                if newHeight >= contentViewController.maxHeight - 0.1 {
                    return
                }

                if abs(newHeight - contentViewController.maxHeight) < 1.5 {
                    newHeight = contentViewController.maxHeight
                }

                if abs(newHeight - contentViewController.minHeight) < 1.5 {
                    newHeight = contentViewController.minHeight
                }

                heightConstraint?.isActive = false

                view.pinHeight(equalTo: newHeight).isActive = true

                superview.layoutIfNeeded()
            default:
                break
        }

        if !(view.frame.origin.y.isEqual(to: 40.0) && contentViewController.contentScrollView.contentOffset.y != 0.0) {
            contentViewController.contentScrollView.contentOffset = CGPoint.zero
        }
    }
}

extension FloatingPanelViewController: UIScrollViewDelegate {
    private func finishScroll() {
        let currentHeight = view.frame.height

        if isScrollDownDirection {
            if currentHeight > contentViewController.minHeight &&
                currentHeight < contentViewController.maxHeight {
                if (currentHeight - contentViewController.minHeight) < (contentViewController.maxHeight - currentHeight) {
                    moveToHeight(contentViewController.minHeight)
                } else {
                    moveToInitialFrame()
                }
            }
        } else {
            moveToInitialFrame()
        }
    }

    private func moveToHeight(_ height: CGFloat) {
        heightConstraint?.isActive = false
        view.pinHeight(equalTo: height).isActive = true

        let time = (panelHeight - view.frame.height) / panelHeight
        let duration = time > 0 ? time : 0.0
        UIView.animate(withDuration: Double(duration)) {
            self.parent?.view.layoutIfNeeded()
        }
    }

    private func moveToInitialFrame() {
        heightConstraint?.isActive = false
        view.pinHeight(equalTo: panelHeight).isActive = true

        let time = (panelHeight - view.frame.height) / panelHeight
        let duration = time > 0 ? time : 0.0
        UIView.animate(withDuration: Double(duration)) {
            self.parent?.view.layoutIfNeeded()
        }
    }
}
