import Foundation

struct MyLoginFactory: LoginFactory {
    
    func makeLoginInspector() -> LoginViewControllerDelegate {
        // Создаем и возвращаем экземпляр LoginInspector
        return LoginInspector()
    }
}
