import UIKit

class LoginInspector: LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool {
        // Используем синглтон Checker для проверки
        return Checker.shared.check(login: login, password: password)
    }
}
