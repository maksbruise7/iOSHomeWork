import UIKit


class User {
    let login: String
    let fullName: String
    let avatar: UIImage
    let status: String
    let password: String // Добавляем пароль для проверки
    
    init(login: String, password: String, fullName: String, avatar: UIImage, status: String) {
        self.login = login
        self.password = password
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
    }
}


protocol UserService {
    func getUser(byLogin login: String) -> User?
}


class CurrentUserService: UserService {
    private let user: User
    
    init() {
        // Реальный пользователь для Release сборки
        self.user = User(
            login: "admin",
            password: "password123",
            fullName: "Hipster Cat",
            avatar: UIImage(named: "Avatar") ?? UIImage(systemName: "person.circle.fill") ?? UIImage(),
            status: "Waiting for something..."
        )
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
        // Тестовый пользователь для Debug сборки
        self.testUser = User(
            login: "test_user",
            password: "test123",
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
