import UIKit

//      Модель пользователя
class User {
    let login: String
    let fullName: String
    let avatar: UIImage
    let status: String
    
    init(login: String, fullName: String, avatar: UIImage, status: String) {
        self.login = login
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
    }
}

//      Протокол сервиса пользователей
protocol UserService {
    func getUser(byLogin login: String) -> User?
}

//      Сервис текущего пользователя
class CurrentUserService: UserService {
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    func getUser(byLogin login: String) -> User? {
        if login == user.login {
            return user
        }
        return nil
    }
}

class TestUserService: UserService {
    private let testUser: User
    
    init() {
//      Создаем тестового пользователя с явно тестовыми данными
        self.testUser = User(
            login: "test_user",
            fullName: "Test User Debug",
            avatar: UIImage(systemName: "person.circle.fill") ?? UIImage(),
            status: "This is a DEBUG test account"
        )
    }
    
    func getUser(byLogin login: String) -> User? {
        if login == testUser.login {
            return testUser
        }
        return nil
    }
}
