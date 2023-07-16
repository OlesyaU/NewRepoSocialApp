//
//  ExtensionViewController.swift
//  SocialApp
//
//  Created by Олеся on 02.07.2023.
//

import UIKit
extension UIViewController {
    func addChildViewController(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func removeChildViewController(_ child: UIViewController) {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        child.view.removeFromSuperview()
        removeFromParent()
    }
}
