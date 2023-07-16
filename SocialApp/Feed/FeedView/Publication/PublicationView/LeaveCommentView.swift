//
//  LeaveCommentView.swift
//  SocialApp
//
//  Created by Олеся on 07.07.2023.
//

import  UIKit
final class LeaveCommentView: UIView {
    private var viewModel: PublicationViewModel?
    private var viewConstraints: [NSLayoutConstraint] = []
    private enum Constants {
        static let inset: CGFloat = 16
        static let iconHeight: CGFloat = 24
    }


    private lazy var iconImage: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFill
        return image
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        [iconImage, titleLabel].forEach({$0.forAutolayout()})
        [iconImage, titleLabel].forEach({addSubview($0)})
        viewConstraints.append(contentsOf: [

            iconImage.pinTop(to: safeAreaLayoutGuide.topAnchor, inset: Constants.inset),
            iconImage.pinHeight(equalTo: Constants.iconHeight),
            iconImage.pinWidth(equalTo: Constants.iconHeight),
            iconImage.pinLeading(to: safeAreaLayoutGuide.leadingAnchor, inset: Constants.inset),

            titleLabel.pinTop(to: safeAreaLayoutGuide.topAnchor, inset: Constants.inset),
            titleLabel.pinLeading(to: iconImage.trailingAnchor, inset: Constants.inset),
            titleLabel.pinBottom(to: bottomAnchor, inset: Constants.inset)
        ])
        NSLayoutConstraint.activate(viewConstraints)
    }

    func configure(viewModel: PublicationViewModel) {
        self.viewModel = viewModel
        backgroundColor = viewModel.leaveCommentViewColor
        titleLabel.text = viewModel.leaveCommentString
        titleLabel.font = viewModel.fontRegular
        titleLabel.textColor = viewModel.leaveCommentStringColor
        iconImage.image = UIImage(systemName: viewModel.leaveCommentIcon)
        iconImage.tintColor = viewModel.colorTitle
    }
}

