import Foundation
import Combine

class LoginViewModel {
    
    // MARK: - Published Properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isLoginSuccess: Bool = false
    
    // MARK: - Dependencies
    private let loginDelegate: LoginViewControllerDelegate
    
    // MARK: - Initializer
    init(loginDelegate: LoginViewControllerDelegate = LoginInspector()) {
        self.loginDelegate = loginDelegate
    }
    
    // MARK: - Public Methods
    func validateEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func validatePassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    func login() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Валидация
        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty else {
            errorMessage = "Пожалуйста, заполните все поля"
            return
        }
        
        guard validateEmail(trimmedEmail) else {
            errorMessage = "Пожалуйста, введите корректный email адрес"
            return
        }
        
        guard validatePassword(trimmedPassword) else {
            errorMessage = "Пароль должен содержать минимум 6 символов"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        loginDelegate.checkCredentials(email: trimmedEmail, password: trimmedPassword) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success:
                    self?.isLoginSuccess = true
                    self?.errorMessage = nil
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.isLoginSuccess = false
                }
            }
        }
    }
    
    func reset() {
        email = ""
        password = ""
        isLoading = false
        errorMessage = nil
        isLoginSuccess = false
    }
}
