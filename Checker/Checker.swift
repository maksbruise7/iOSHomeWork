import Foundation

final class Checker {
    static let shared = Checker()
    
//      Статические данные для проверки
    private let validLogin = "admin"
    private let validPassword = "password123"
    
//      Тестовые данные для DEBUG режима
    #if DEBUG
    private let testLogin = "test_user"
    private let testPassword = "test123"
    #endif
    
    private init() {}
    
    func check(login: String, password: String) -> Bool {
        #if DEBUG
//      В DEBUG режиме проверяем и реального, и тестового пользователя
        return (login == validLogin && password == validPassword) ||
               (login == testLogin && password == testPassword)
        #else
//      В RELEASE режиме только реального пользователя
        return login == validLogin && password == validPassword
        #endif
    }
}
