//import FirebaseAuth

import Foundation

class EnterPhoneNumberViewModel {
    
    private var confirmControllerViewModel: ConfirmControllerViewModel?
    private (set) var state: State = .viewIsReady {
        didSet{
            viewModelChanged?(state)
        }
    }

    let welcomeLabelTitle = "ЗАРЕГИСТРИРОВАТЬСЯ"
    let pushNumberUserTitle = "Введите номер"
    let secondLabelTitle = "Ваш номер телефона будет использоваться для входа в приложение"
    let placeholderString = "+7 _ _ _  _ _ _  _ _  _ _"
    let buttonTitle = "ДАЛЕЕ"
    let privacyLabelTitle = "Нажимая кнопку \"Далее\"  Вы принимаете \n пользовательское Соглашение и политику конфиденциальности"
    let alertTitle = "OOPPPSS"
    let alertMessage = "The phone number is incorrect. Please write correctly"
    let actionTitle = "OMG! SURE THING"
    var passNewUserData: ((_ phoneNumber: String, _ code : String) -> Void)?
    var phoneNumber: String?
    var viewModelChanged: ((_ state: State)-> Void)?

    private func enterNumberPhone(phone: String) {
        if  validate(phone: phone) {
            let code = String(describing: Array(repeating: Int.random(in: 0...9), count: 6)).applyPatternOnNumbers(pattern: "# # # # # #", replacementCharacter: "#")
            confirmControllerViewModel = ConfirmControllerViewModel(viewModel: self)
            passNewUserData?(phone,code)
            print("NewUser data phone: \(phone), code: \(code)")
        } else {
            state = .error
        }
    }

    private func validate(phone: String) -> Bool {
        let PHONE_REGEX = "[+][7][ ][0-9]{3}[ ][0-9]{3}[ ][0-9]{2}[ ][0-9]{2}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: phone)
        return result
    }

    func changeState(_ state: State) {
        guard let phoneNumber = phoneNumber else { return }
        switch state {
            case .viewIsReady:
                print("view model state \(state)")
            case .buttonTapped:
                enterNumberPhone(phone: phoneNumber)
                print("view model state \(state)")
            case .error:
                print("view model state \(state)")
            case .success:
                print("view model state \(state)")
        }
    }
}


