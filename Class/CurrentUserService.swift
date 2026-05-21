import Foundation

class CurrentUserService: UserService {
    
    private let user: User
    
    // Инициализация через внедрение пользователя
    init(user: User) {
        self.user = user
    }
    
    func getUser(byLogin login: String) -> User? {
        // Возвращаем пользователя только если логин совпадает
        return login == user.login ? user : nil
    }
}
