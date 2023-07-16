
import UIKit

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIView {
    enum Side {
        case left
        case right
        case top
        case bottom
        case all
    }

    func placed(on view: UIView) {
        view.addSubview(self)
    }

    func pinEdges(to view: UIView, insets: UIEdgeInsets = .zero, excluding side: Side = .all) -> [NSLayoutConstraint] {
        switch side {
            case .all:
            return [
                pinTop(to: view, inset: insets.top),
                pinBottom(to: view, inset: insets.bottom),
                pinLeading(to: view, inset: insets.left),
                pinTrailing(to: view, inset: insets.right),
                ]
            case .left:
            return [
                pinTop(to: view, inset: insets.top),
                pinBottom(to: view, inset: insets.bottom),
                pinTrailing(to: view, inset: insets.right)
                ]
            case .right:
            return [
                pinTop(to: view, inset: insets.top),
                pinBottom(to: view, inset: insets.bottom),
                pinLeading(to: view, inset: insets.left)
                ]
            case .top:
            return [
                pinBottom(to: view, inset: insets.bottom),
                pinLeading(to: view, inset: insets.left),
                pinTrailing(to: view, inset: insets.right)
                ]
            case .bottom:
            return [
                pinTop(to: view, inset: insets.top),
                pinLeading(to: view, inset: insets.left),
                pinTrailing(to: view, inset: insets.right)
                ]
        }
    }

    @discardableResult
    func pinTop(to view: UIView, inset: CGFloat = .zero) -> NSLayoutConstraint {
        topAnchor.constraint(equalTo: view.topAnchor, constant: inset)
    }

    @discardableResult
    func pinTop(to anchor: NSLayoutYAxisAnchor, inset: CGFloat = .zero) -> NSLayoutConstraint {
        topAnchor.constraint(equalTo: anchor, constant: inset)
    }

    @discardableResult
    func pinTopGreaterThanOrEqual(to anchor: NSLayoutYAxisAnchor, inset: CGFloat = .zero) -> NSLayoutConstraint {
        topAnchor.constraint(greaterThanOrEqualTo: anchor, constant: inset)
    }

    @discardableResult
    func pinTopLessThanOrEqualTo(to anchor: NSLayoutYAxisAnchor, inset: CGFloat = .zero) -> NSLayoutConstraint {
        topAnchor.constraint(lessThanOrEqualTo: anchor, constant: inset)
    }

    @discardableResult
    func pinBottom(to view: UIView, inset: CGFloat = .zero) -> NSLayoutConstraint {
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset)
    }

    @discardableResult
    func pinBottom(to anchor: NSLayoutYAxisAnchor, inset: CGFloat = .zero) -> NSLayoutConstraint {
        bottomAnchor.constraint(equalTo: anchor, constant: -inset)
    }

    @discardableResult
    func pinLeading(to view: UIView, inset: CGFloat = .zero) -> NSLayoutConstraint {
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset)
    }

    @discardableResult
    func pinLeading(to anchor: NSLayoutXAxisAnchor, inset: CGFloat = .zero) -> NSLayoutConstraint {
        leadingAnchor.constraint(equalTo: anchor, constant: inset)
    }

    @discardableResult
    func pinTrailing(to view: UIView, inset: CGFloat = .zero) -> NSLayoutConstraint {
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset)
    }

    @discardableResult
    func pinTrailing(to anchor: NSLayoutXAxisAnchor, inset: CGFloat = .zero) -> NSLayoutConstraint {
        trailingAnchor.constraint(equalTo: anchor, constant: -inset)
    }

    func pinCenter(to view: UIView, insetX: CGFloat = .zero, insetY: CGFloat = .zero) {
        pinCenterX(to: view, inset: insetX)
        pinCenterY(to: view, inset: insetY)
    }

    @discardableResult
    func pinCenterX(to view: UIView, inset: CGFloat = .zero) -> NSLayoutConstraint {
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: inset)
    }

    @discardableResult
    func pinCenterY(to view: UIView, inset: CGFloat = .zero) -> NSLayoutConstraint {
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: inset)
    }

    @discardableResult
    func pinHeight(equalTo: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
        heightAnchor.constraint(equalTo: equalTo, multiplier: multiplier, constant: constant)
    }

    @discardableResult
    func pinHeight(equalTo view: UIView, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        heightAnchor.constraint(
            equalTo: view.heightAnchor,
            multiplier: multiplier,
            constant: constant
        )
    }

    @discardableResult
    func pinHeight(equalTo constant: CGFloat) -> NSLayoutConstraint {
        heightAnchor.constraint(equalToConstant: constant)
    }

    @discardableResult
    func pinWidth(equalTo constant: CGFloat) -> NSLayoutConstraint {
       widthAnchor.constraint(equalToConstant: constant)
    }

    func pinWeight(equalTo view: UIView, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        widthAnchor.constraint(
            equalTo: view.widthAnchor,
            multiplier: multiplier,
            constant: constant
        )
    }

    @discardableResult
    func pinWidth(constant: CGFloat, multiplier: CGFloat) -> NSLayoutConstraint {
        widthAnchor.constraint(equalToConstant: constant)
    }

    @discardableResult
    func cornerRadius(cornerRadius: CGFloat = 16) -> Self {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        return self
    }

    @discardableResult
    func forAutolayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}

extension NSLayoutConstraint {
    @discardableResult
    func activated() -> Self {
        isActive = true
        return self
    }
}

extension UIView {
    func setShadow(color: UIColor, radius: CGFloat, offset: CGSize, opacity: Float) {
            layer.shadowColor = color.cgColor
            layer.shadowRadius = radius
            layer.shadowOffset = offset
            layer.shadowOpacity = opacity
        }
}

extension String {
    func applyPatternOnNumbers(pattern: String, replacementCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)

        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}
extension UIButton {
    func applyIcon(name: String, tintColor: UIColor?, imageEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 6)) {
        var image = UIImage(named: name)
        if let tintColor = tintColor {
            image = image?.withRenderingMode(.alwaysTemplate)
            self.tintColor = tintColor
        }
        setImage(image, for: .normal)
//        self.imageEdgeInsets = imageEdgeInsets

    }
    func applyIcon(systemName: String, tintColor: UIColor?, imageEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 6)) {
        var image = UIImage(systemName: systemName)
        if let tintColor = tintColor {
            image = image?.withRenderingMode(.alwaysTemplate)
            self.tintColor = tintColor
        }
        setImage(image, for: .normal)
//        self.imageEdgeInsets = imageEdgeInsets

    }
}
