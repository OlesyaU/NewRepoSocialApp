//
//  ConfirmControllerViewModel.swift
//  SocialApp
//
//  Created by Олеся on 10.07.2023.
//
import UIKit
import FirebaseAuth
enum State {
    case input
    case error
    case correct
}

final class ConfirmControllerViewModel {
    let confirmLabelTitle = "Подтверждение регистрации"
    let pushNumberUserTitle = "Мы отправили SMS с кодом на номер"
    let numberLabelTitle = "+7 999 999 99 99"
    let badgeText = "Введите код из SMS"
    let placeholderString = "_ _ _ _ _ _"
    let buttonTitle = "ЗАРЕГИСТРИРОВАТЬСЯ"
    let readyImage = UIImage(named: "Ready")
    let boldFont = UIFont.textBold
    let regularFont = UIFont.textRegular
    let badgeFont = UIFont.badgeFont
    let orangeColor = AppColors.orange
    let grayColor = AppColors.gray
    let lightGray = AppColors.lightGray
    let darkGray = AppColors.darkGray
    let centerText = TextAttribute.centerText
    let leftText = TextAttribute.leftText
    let blackColor = AppColors.black

    private var state: State = .input {
        didSet {
            viewModelChanged?()
        }
    }
    var viewModelChanged: (() -> Void)?

    func registerNewUser(phone: String,  generatedCode: String) {
        if  phone != "", validate(code: generatedCode) {

            let number = Int.random(in: 0...99)
            Auth.auth().createUser(withEmail: "\(number)@mail.ru", password: phone)
            { [weak self] authResult, error in
                if let error {
                    self?.state = .error
                    print("Error with registration \(error.localizedDescription)")
                    return
                }
            }
        } else {
            state = .error
        }
    }

    func validate(code: String) -> Bool {
        let CODE_REGEX = "[0-9]{1}[ ][0-9]{1}[ ][0-9]{1}[ ][0-9]{1}[ ][0-9]{1}[ ][0-9]{1}"
        let codeTest = NSPredicate(format: "SELF MATCHES %@", CODE_REGEX)
        var result = codeTest.evaluate(with: code)
        //    print("code validate \(code)")

        return result
    }
    //не знаю каr правильно проверить на правильность проверочный код(((
}


