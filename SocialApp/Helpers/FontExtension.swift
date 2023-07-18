//
//  FontExtension.swift
//  SocialApp
//
//  Created by Олеся on 29.06.2023.
//

import UIKit

extension UIFont {
    static let textBold = UIFont(name: "AvenirNextCondensed-Bold", size: 18)
    static let textRegular = UIFont(name: "AvenirNextCondensed-Regular", size: 16)
    static let lightFont = UIFont(name: "AvenirNextCondensed-Light", size: 14)
    static let badgeFont = UIFont(name: "AvenirNextCondensed-UltraLight", size: 12)
}

// TODO: - Refactor to prepared icons
enum IconsName {
    case dots
    case leftArrow
    case rightArrow
    case burger
    case moreInfo
    case likes
    case likesFill
    case comments
    case bookmark
    case paperclip
    case close
    case star
    case files
    case archive
    case settings
    case starFill
    case house
    case person

    var icon: UIImage? {
        if let image = UIImage(named: nameIcon) {
            return image
        } else {
            return UIImage(systemName: nameIcon)
        }
    }

    var nameIcon: String {
        switch self {
            case .dots:
                return  "DotsVertical"
            case .leftArrow:
                return   "arrow.left"
            case .rightArrow:
                return  "chevron.right"
            case .burger:
                return  "line.3.horizontal"
            case .moreInfo:
                return  "exclamationmark.circle.fill"
            case .likes:
                return "heart"
            case .comments:
                return "message"
            case .bookmark:
                return "bookmark"
            case .paperclip:
                return "paperclip"
            case .likesFill:
                return "heart.fill"
            case .close:
                return "xmark"
            case .star:
                return "star"
            case .files:
                return "tray.and.arrow.up"
            case .archive:
                return "link"
            case .settings:
                return "gearshape"
            case .starFill:
                return "star.fill"
            case .house:
                return "house"
            case .person:
                return  "person.circle"
        }
    }
}


extension UIBarButtonItem {

    static func menuButton(_ target: Any?, action: Selector, imageName: String, tintColor: UIColor) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.tintColor = tintColor
        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true

        return menuBarItem
    }
}
