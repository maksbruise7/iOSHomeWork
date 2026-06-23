import UIKit

// MARK: - User Model
class User {
    let login: String
    let fullName: String
    let avatar: UIImage
    let status: String
    let password: String
    
    init(login: String, password: String, fullName: String, avatar: UIImage, status: String) {
        self.login = login
        self.password = password
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
    }
}

// MARK: - User Service Protocol
protocol UserService {
    func getUser(byLogin login: String) -> User?
}

// MARK: - Current User Service (Release)
class CurrentUserService: UserService {
    private let users: [String: User]
    
//      Данные передаются через инициализатор
    init(users: [User]) {
        var usersDict = [String: User]()
        for user in users {
            usersDict[user.login] = user
        }
        self.users = usersDict
    }
    
    func getUser(byLogin login: String) -> User? {
        return users[login]
    }
}

// MARK: - Test User Service (Debug)
class TestUserService: UserService {
    private let users: [String: User]
    
//      Данные передаются через инициализатор
    init(users: [User]) {
        var usersDict = [String: User]()
        for user in users {
            usersDict[user.login] = user
        }
        self.users = usersDict
    }
    
    func getUser(byLogin login: String) -> User? {
        return users[login]
    }
}
