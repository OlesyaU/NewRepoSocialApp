//
//  String Extension.swift
//  SocialApp
//
//  Created by Олеся on 21.07.2023.
//

import Foundation
infix operator ?=

extension String {
    static func ?= (left: String?, right: String) -> Bool {
        let word = left != nil ? left : right
        return left == word
    }
}
