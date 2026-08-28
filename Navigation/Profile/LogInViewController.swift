import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    weak var coordinator: LoginCoordinator?
    var loginDelegate: LoginViewControllerDelegate?
    
    lazy var profileView: ProfileTableHederView = {
        let view = ProfileTableHederView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(profileView)
        constraints()
        setupButtonTarget()
        notification()
        
        profileView.logInAccount.text = "test@example.com"
        profileView.password.text = "test123"
        
        if loginDelegate == nil {
            print("❌ loginDelegate не установлен!")
        } else {
            print("✅ loginDelegate установлен")
        }
    }
    
    private func setupButtonTarget() {
        profileView.logInButton.setAction { [weak self] in
            self?.handleLogin()
        }
    }
    
    private func handleLogin() {
        view.endEditing(true)
        
        guard let rawEmail = profileView.logInAccount.text,
              let rawPassword = profileView.password.text else {
            showAlert(message: "Пожалуйста, заполните все поля")
            return
        }
        
        let email = rawEmail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let password = rawPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !email.isEmpty, !password.isEmpty else {
            showAlert(message: "Пожалуйста, заполните все поля")
            return
        }
        
        guard isValidEmail(email) else {
            showAlert(message: "Пожалуйста, введите корректный email адрес (пример: user@example.com)")
            return
        }
        
        guard password.count >= 6 else {
            showAlert(message: "Пароль должен содержать минимум 6 символов")
            return
        }
        
        guard let delegate = loginDelegate else {
            showAlert(message: "Ошибка сервиса авторизации")
            return
        }
        
        print("🔍 Попытка входа: '\(email)'")
        showLoading(true)
        
        delegate.checkCredentials(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.showLoading(false)
                switch result {
                case .success(let user):
                    print("✅ Успешный вход: \(user.fullName)")
                    self?.coordinator?.navigateToProfile(with: user)
                case .failure(let error):
                    print("❌ Ошибка: \(error.localizedDescription)")
                    self?.showAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func showLoading(_ isLoading: Bool) {
        profileView.logInButton.isEnabled = !isLoading
        profileView.logInButton.setTitle(isLoading ? "Загрузка..." : "Log in", for: .normal)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func notification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
