//
//  Alert.swift
//  SocialApp
//
//  Created by Олеся on 21.07.2023.
//

import UIKit

final class Alert {

    class func showAleart(for viewController: UIViewController, with title: String, aleartMessage: String, action1Title: String, handler: ((UIAlertAction) -> Void)?, action2Title: String?){
        let aleart = UIAlertController(title: title, message: aleartMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: action1Title, style: .destructive, handler: handler)
        if action2Title != nil {
            let action2 = UIAlertAction(title: action2Title, style: .cancel)

            aleart.addAction(action2)
        }
        aleart.addAction(action)
        viewController.present(aleart, animated: true)
    }
}
