import FirebaseAuth

class EnterPhoneNumberViewModel {

    // TODO: - Обработка ошибок ввода
    enum State {
        case input
        case error
        case correct
    }

    private var verificationId: String?
    private var verificationCode: String?
    private var user: User?

    let welcomeLabelTitle = "ЗАРЕГИСТРИРОВАТЬСЯ"
    let pushNumberUserTitle = "Введите номер"
    let secondLabelTitle = "Ваш номер телефона будет использоваться для входа в приложение"
    let placeholderString = "+7 _ _ _  _ _ _  _ _  _ _"
    let buttonTitle = "ДАЛЕЕ"
    let privacyLabelTitle = "Нажимая кнопку \"Далее\"  Вы принимаете \n пользовательское Соглашение и политику конфиденциальности"
    private var state: State = .input {
        didSet {
            viewModelChanged?()
        }
    }

    var viewModelChanged: (() -> Void)?

    func testing(string: String){
        let number = Int.random(in: 0...99)
        Auth.auth().createUser(withEmail: "\(number)@mail.ru", password: string) { authResult, error in
        }
        state = .correct
        print("Current user UID \(Auth.auth().currentUser?.uid)")
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
