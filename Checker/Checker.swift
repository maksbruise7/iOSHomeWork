import Foundation

final class Checker {
    static let shared = Checker()
    
    private var validLogin: String
    private var validPassword: String
    
//      Приватный инициализатор для синглтона
    private init() {
//      Данные теперь будут устанавливаться через метод setup
        self.validLogin = ""
        self.validPassword = ""
    }
    
//      Метод для настройки данных проверки
    func setup(login: String, password: String) {
//      Используем guard чтобы данные можно было установить только один раз
        guard validLogin.isEmpty && validPassword.isEmpty else {
            print("Checker уже настроен")
            return
        }
        
        self.validLogin = login
        self.validPassword = password
    }
    
    func check(login: String, password: String) -> Bool {
        return login == validLogin && password == validPassword
    }
}
