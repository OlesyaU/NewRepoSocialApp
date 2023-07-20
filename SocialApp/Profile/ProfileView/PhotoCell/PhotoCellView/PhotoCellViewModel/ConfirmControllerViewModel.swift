//
//  ConfirmControllerViewModel.swift
//  SocialApp
//
//  Created by Олеся on 10.07.2023.
//
import UIKit
import FirebaseAuth

final class ConfirmControllerViewModel {
    private let enteredViewModel: EnterPhoneNumberViewModel
    private static var generatedCode = ""
    private static var phoneNumberForRegister = ""

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

    init(viewModel: EnterPhoneNumberViewModel) {
        enteredViewModel = viewModel
        getCode()
        getNumber()
    }

    private func getCode() {
        enteredViewModel.passCode = {  code in
            ConfirmControllerViewModel.generatedCode = code
        }
    }

    private func getNumber() {
        enteredViewModel.passPhoneNumber = { num in
            ConfirmControllerViewModel.phoneNumberForRegister = num
        }
    }

    private func registerNewUser(phone: String) {
        let number = Int.random(in: 0...1000)
        Auth.auth().createUser(withEmail: "\(number)@mail.ru", password: phone) {
            authResult, error in
            if let error {
                print("Error with registration \(error.localizedDescription)")
                return
            }
            print("New user is \(String(describing: authResult?.user)) register success")
        }
    }

    func validate(code: String) -> Bool {
        let generatedCode = ConfirmControllerViewModel.generatedCode
        let phoneForRegister = ConfirmControllerViewModel.phoneNumberForRegister
        var codeResult = false
        codeResult = code == generatedCode
        let CODE_REGEX = "[0-9]{1}[ ][0-9]{1}[ ][0-9]{1}[ ][0-9]{1}[ ][0-9]{1}[ ][0-9]{1}"
        let codeTest = NSPredicate(format: "SELF MATCHES %@", CODE_REGEX)
        let regexResult = codeTest.evaluate(with: code)
        if codeResult {
            registerNewUser(phone: phoneForRegister)
        } else {
            return false
        }
        return regexResult == codeResult
    }
}

