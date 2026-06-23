import UIKit

class LogInViewController: UIViewController {
    
    // MARK: - Properties
    lazy var profileView: ProfileTableHederView = {
        let view = ProfileTableHederView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var userService: UserService?
    var loginDelegate: LoginViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(profileView)
        constraints()
        setupButtonTarget()
        notification()
        setupUserService()
        
        #if DEBUG
        print("📍 DEBUG режим")
        profileView.logInAccount.text = "test_user"
        profileView.password.text = "test123"
        #else
        print("📍 RELEASE режим")
        #endif
    }
    
    private func setupUserService() {
        #if DEBUG
        let users = DataProvider.getTestUsers()
        userService = TestUserService(users: users)
        #else
        let users = DataProvider.getRealUsers()
        userService = CurrentUserService(users: users)
        #endif
    }
    
    private func setupButtonTarget() {
        profileView.logInButton.setAction { [weak self] in
            self?.loginButtonTapped()
        }
    }
    
    // MARK: - Actions
    @objc private func loginButtonTapped() {
        view.endEditing(true)
        
        guard let login = profileView.logInAccount.text, !login.isEmpty,
              let password = profileView.password.text, !password.isEmpty else {
            showAlert(message: "Пожалуйста, заполните все поля")
            return
        }
        
        guard let delegate = loginDelegate else {
            print("❌ Ошибка: loginDelegate не установлен")
            showAlert(message: "Ошибка сервиса авторизации")
            return
        }
        
        let isValidCredentials = delegate.check(login: login, password: password)
        
        if !isValidCredentials {
            showAlert(message: "Неверный логин или пароль")
            return
        }
        
        guard let user = userService?.getUser(byLogin: login) else {
            showAlert(message: "Пользователь с таким логином не найден")
            return
        }
        
        print("✅ Успешный вход! Пользователь: \(user.fullName)")
        navigateToProfile(with: user)
    }
    
    // ИСПРАВЛЕННЫЙ МЕТОД НАВИГАЦИИ
    private func navigateToProfile(with user: User) {
        let profileVC = ProfileViewController()
        
        // Создаем ViewModel с сервисом и логином пользователя
        #if DEBUG
        let users = DataProvider.getTestUsers()
        let userService: UserService = TestUserService(users: users)
        #else
        let users = DataProvider.getRealUsers()
        let userService: UserService = CurrentUserService(users: users)
        #endif
        
        let viewModel = ProfileViewModel(userService: userService, userLogin: user.login)
        profileVC.viewModel = viewModel
        
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
    
    // MARK: - Keyboard Handling
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

// MARK: - UITextFieldDelegate
extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
