

import Foundation
import UIKit

protocol SetThemeColorProtocol {
    func setColor()
}

extension UIColor {
    static let textFieldColor = UIColor(named: "textSecondary")!
    static let backgroundPrimary = UIColor(named: "backgroundPrimary")!
    static let textPrimary = UIColor(named: "textPrimary")!
    static let contentColor = UIColor(named: "contentColor")!
    static let buttonColor = UIColor(named: "buttonColor")

}

extension UIImage {
    static let buttonBackgroundImageNormal = UIImage(named: "buttonNormal")
    static let buttonBackgroundImageSelected = UIImage(named: "buttonSelected")
}

