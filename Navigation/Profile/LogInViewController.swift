import UIKit

class LogInViewController: UIViewController {
    

    lazy var profileView: ProfileTableHederView = {
        let view = ProfileTableHederView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var userService: UserService?
    var loginDelegate: LoginViewControllerDelegate? // Делегат для проверки
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(profileView)
        constraints()
        setupUserService()
        setupButtonTarget()
        notification()
        
        // Для отладки - выводим информацию о текущей схеме сборки
        #if DEBUG
        print("Приложение запущено в DEBUG режиме")
        print("Используется TestUserService")
        // Автоматически заполняем поля для удобства тестирования
        profileView.logInAccount.text = "test_user"
        profileView.password.text = "test123"
        #else
        print("Приложение запущено в RELEASE режиме")
        print("Используется CurrentUserService")
        #endif
    }
    

    private func setupUserService() {
        #if DEBUG
        userService = TestUserService()
        #else
        userService = CurrentUserService()
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
        // Скрываем клавиатуру
        view.endEditing(true)
        
        guard let login = profileView.logInAccount.text, !login.isEmpty,
              let password = profileView.password.text, !password.isEmpty else {
            showAlert(message: "Пожалуйста, заполните все поля")
            return
        }
        
        // Шаг 1: Проверяем логин и пароль через делегат (LoginInspector -> Checker)
        guard let delegate = loginDelegate else {
            print("Ошибка: loginDelegate не установлен")
            showAlert(message: "Ошибка сервиса авторизации")
            return
        }
        
        let isValidCredentials = delegate.check(login: login, password: password)
        
        if !isValidCredentials {
            showAlert(message: "Неверный логин или пароль")
            return
        }
        
        // Шаг 2: Если логин и пароль верны, получаем данные пользователя через UserService
        guard let user = userService?.getUser(byLogin: login) else {
            showAlert(message: "Пользователь с таким логином не найден")
            return
        }
        
        // Шаг 3: Переходим к профилю
        #if DEBUG
        print("Успешный вход! Пользователь: \(user.fullName)")
        #else
        print("Успешный вход! Пользователь: \(user.fullName)")
        #endif
        
        navigateToProfile(with: user)
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
