import UIKit

// Класс пользователя
class User {
    let login: String
    let fullName: String
    let avatar: UIImage?
    let status: String
    
    init(login: String, fullName: String, avatar: UIImage?, status: String) {
        self.login = login
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
    }
}

// Протокол сервиса
protocol UserService {
    func getUser(login: String) -> User?
}

// Реализация сервиса для текущего пользователя
class CurrentUserService: UserService {
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
    func getUser(login: String) -> User? {
        return login == user.login ? user : nil
    }
}
