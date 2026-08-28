import UIKit

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

protocol UserService {
    func getUser(byLogin login: String) -> User?
}

class CurrentUserService: UserService {
    private let users: [String: User]
    
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

class TestUserService: UserService {
    private let users: [String: User]
    
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
