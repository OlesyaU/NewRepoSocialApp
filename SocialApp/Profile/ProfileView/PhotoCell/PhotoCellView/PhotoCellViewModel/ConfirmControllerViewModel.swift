//
//  ConfirmControllerViewModel.swift
//  SocialApp
//
//  Created by Олеся on 10.07.2023.
//
import UIKit
import FirebaseAuth

final class ConfirmControllerViewModel {
    private struct NewUser {
        var code: String
        var phone: String
    }
    private static var newUser: NewUser?
    private (set) var state: State = .viewIsReady {
        didSet{
            viewModelChanged?(state)
        }
    }
    private let enterPhoneNumberViewModel: EnterPhoneNumberViewModel
    let confirmLabelTitle = "Подтверждение регистрации"
    let pushNumberUserTitle = "Мы отправили SMS с кодом на номер"
    let numberLabelTitle = "+7 999 999 99 99"
    let badgeText = "Введите код из SMS"
    let placeholderString = "_ _ _ _ _ _"
    let buttonTitle = "ЗАРЕГИСТРИРОВАТЬСЯ"
    let alertTitle = "OOPPPSS"
    let alertMessage = "The code is incorrect. Please write correctly"
    let actionTitle = "OMG! SURE THING"
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
    var result: Bool?
    var codeFromConfirmPhoneNumberViewModel: String?
    var viewModelChanged: ((_ state: State)-> Void)?

    init(viewModel: EnterPhoneNumberViewModel) {
        enterPhoneNumberViewModel = viewModel
        getCodeNewUserData()
    }

    private func getCodeNewUserData() {
        enterPhoneNumberViewModel.passNewUserData = { phone, code in
            ConfirmControllerViewModel.newUser = NewUser(code: code, phone: phone)
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
        guard let generatedCode = ConfirmControllerViewModel.newUser?.code else { return false }
        var codeResult = false
        codeResult = code == generatedCode
        let CODE_REGEX = "[0-9]{1}[ ][0-9]{1}[ ][0-9]{1}[ ][0-9]{1}[ ][0-9]{1}[ ][0-9]{1}"
        let codeTest = NSPredicate(format: "SELF MATCHES %@", CODE_REGEX)
        let regexResult = codeTest.evaluate(with: code)
        return regexResult == codeResult
    }

    func changeState(_ state: State) {
        switch state {
            case .viewIsReady:
                print("view model state \(state)")
            case .buttonTapped:
                guard let code = codeFromConfirmPhoneNumberViewModel else { return }
                result =  validate(code: code)
                print("view model state \(state)")
            case .error:
                print("view model state \(state)")
            case .success:
                guard let phoneForRegister = ConfirmControllerViewModel.newUser?.phone else { return }
                registerNewUser(phone: phoneForRegister)
                print("view model state \(state)")
        }
    }
}

