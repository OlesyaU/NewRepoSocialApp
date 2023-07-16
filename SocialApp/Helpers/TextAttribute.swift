//
//  TextAttribute.swift
//  SocialApp
//
//  Created by Олеся on 02.07.2023.
//

import UIKit
struct TextAttribute {
    static  let leftText: NSTextAlignment = TextAlignment.left.aliagment
    static  let rightText: NSTextAlignment = TextAlignment.right.aliagment
    static  let centerText: NSTextAlignment = TextAlignment.center.aliagment
}
 private enum TextAlignment {
    case left
    case right
    case center
    var aliagment: NSTextAlignment {
        switch self {
            case .left:
                return .left
            case .right:
                return .right
            case .center:
                return .center
        }
    }
}
