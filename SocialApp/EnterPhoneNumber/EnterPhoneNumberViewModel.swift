//import FirebaseAuth

import Foundation

class EnterPhoneNumberViewModel {

    private var confirmControllerViewModel: ConfirmControllerViewModel?

    let welcomeLabelTitle = "ЗАРЕГИСТРИРОВАТЬСЯ"
    let pushNumberUserTitle = "Введите номер"
    let secondLabelTitle = "Ваш номер телефона будет использоваться для входа в приложение"
    let placeholderString = "+7 _ _ _  _ _ _  _ _  _ _"
    let buttonTitle = "ДАЛЕЕ"
    let privacyLabelTitle = "Нажимая кнопку \"Далее\"  Вы принимаете \n пользовательское Соглашение и политику конфиденциальности"
    var passCode: ((_ code : String) -> Void)?
    var passPhoneNumber: ((_ code : String) -> Void)?

    func enterNumberPhone(phone: String)                   {
        if  validate(phone: phone) {
            let code = String(describing: Array(repeating: Int.random(in: 0...9), count: 6)).applyPatternOnNumbers(pattern: "# # # # # #", replacementCharacter: "#")
            confirmControllerViewModel = ConfirmControllerViewModel(viewModel: self)
            passCode?(code)
            passPhoneNumber?(phone)
            print("New user data: phone number is \(phone), code is \(code)")
        } else {
            // TODO: - have to implement later
        }
    }

    private func validate(phone: String) -> Bool {
        let PHONE_REGEX = "[+][7][ ][0-9]{3}[ ][0-9]{3}[ ][0-9]{2}[ ][0-9]{2}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: phone)
        return result
    }
}


