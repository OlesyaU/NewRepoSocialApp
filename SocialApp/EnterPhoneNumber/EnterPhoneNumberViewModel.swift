//import FirebaseAuth

import Foundation

class EnterPhoneNumberViewModel {

    enum State {
        case input
        case error
        case correct
    }

    private var verificationId: String?
    private var verificationCode: String?
//    private var user: User?

    let welcomeLabelTitle = "ЗАРЕГИСТРИРОВАТЬСЯ"
    let pushNumberUserTitle = "Введите номер"
    let secondLabelTitle = "Ваш номер телефона будет использоваться для входа в приложение"
    let placeholderString = "+7 _ _ _  _ _ _  _ _  _ _"
    let buttonTitle = "ДАЛЕЕ"
    let privacyLabelTitle = "Нажимая кнопку \"Далее\"  Вы принимаете \n пользовательское Соглашение и политику конфиденциальности"
    var codejjfjf: ((String)-> Void)?
    private var state: State = .input {
        didSet {
            viewModelChanged?()
        }
    }
    var passPhoneNumber: ((_ code : String) -> Void)?
    var viewModelChanged: (() -> Void)?

    func enterNumberPhone(phone: String)                   {
        if  validate(phone: phone) {
            let code = String(describing: Array(repeating: Int.random(in: 0...9), count: 6)).applyPatternOnNumbers(pattern: "# # # # # #", replacementCharacter: "#")
            state = .correct
            ConfirmControllerViewModel().registerNewUser(phone: phone, generatedCode: code)
  print("New user phone \(phone), code \(code)")
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
}


/*
 Нужно доделать регистрацию: ограничив возможно сть для захода только номером с девятками
 Для этого - сделать error state на экране ввода телефона,
 Далее - корректно передавать данные из экрана в экран:
 на экране ввода номера - получаем из authorise - verification id -  передаем его в след экран ( с вводом 6 символов) -
 во вью модель
 В след экране - делаем проверку на введенный код: отправлчяем запрос в фиребас - и парсим ответ
 поправь маску на жкране ввода кода

 обработку паролей, номеров - делать во вьюмоделях!
 */
