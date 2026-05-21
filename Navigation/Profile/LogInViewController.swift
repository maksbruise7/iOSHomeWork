import UIKit

class LogInViewController: UIViewController {
    
    lazy var profileView: ProfileTableHederView = {
        let view = ProfileTableHederView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var userService: UserService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(profileView)
        constraints()
        setupUserService()
        setupButtonTarget()
        notification()
        
//      Для отладки - выводим информацию о текущей схеме сборки
        #if DEBUG
        print("Приложение запущено в DEBUG режиме")
        print("Используется TestUserService")
        #else
        print("Приложение запущено в RELEASE режиме")
        print("Используется CurrentUserService")
        #endif
    }
    
    private func setupUserService() {
        #if DEBUG
//      Для Debug сборки используем TestUserService
        userService = TestUserService()
        
//      Дополнительно: автоматически заполняем поле логина для удобства тестирования
        profileView.logInAccount.text = "test_user"
        
        #else
//      Для Release сборки используем CurrentUserService с реальным пользователем
        let realUser = User(
            login: "admin",
            fullName: "Hipster Cat",
            avatar: UIImage(named: "Avatar") ?? UIImage(systemName: "person.circle.fill") ?? UIImage(),
            status: "Waiting for something..."
        )
        userService = CurrentUserService(user: realUser)
        
        #endif
    }
    
    private func setupButtonTarget() {
        profileView.logInButton.addTarget(
            self,
            action: #selector(loginButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func loginButtonTapped() {
//      Скрываем клавиатуру
        view.endEditing(true)
        
        guard let login = profileView.logInAccount.text, !login.isEmpty else {
            showAlert(message: "Пожалуйста, введите логин")
            return
        }
        
//      Получаем пользователя через сервис
        let user = userService?.getUser(byLogin: login)
        
        if let validUser = user {
            #if DEBUG
            print("DEBUG: Пользователь найден - \(validUser.fullName)")
            #else
            print("RELEASE: Пользователь найден - \(validUser.fullName)")
            #endif
            navigateToProfile(with: validUser)
        } else {
            #if DEBUG
            print("DEBUG: Пользователь с логином '\(login)' не найден")
            #else
            print("RELEASE: Пользователь с логином '\(login)' не найден")
            #endif
            showAlert(message: "Некорректные данные. Пользователь с логином \"\(login)\" не найден.")
        }
    }
    
    private func navigateToProfile(with user: User) {
        let profileVC = ProfileViewController()
        profileVC.user = user
        profileVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func notification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            profileView.scrollView.contentInset = contentInsets
            profileView.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        profileView.scrollView.contentInset = .zero
        profileView.scrollView.scrollIndicatorInsets = .zero
    }
    
    func constraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            profileView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            profileView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            profileView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            profileView.heightAnchor.constraint(equalTo: safeArea.heightAnchor)
        ])
    }
}

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
