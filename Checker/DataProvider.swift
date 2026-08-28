import UIKit

struct DataProvider {
    
    static func getRealUsers() -> [User] {
        let avatarImage = UIImage(named: "Avatar") ?? UIImage(systemName: "person.circle") ?? UIImage()
        return [
            User(login: "admin", password: "password123", fullName: "Hipster Cat", avatar: avatarImage, status: "Waiting for something...")
        ]
    }
    
    static func getTestUsers() -> [User] {
        let avatarImage = UIImage(systemName: "person.circle.fill") ?? UIImage()
        return [
            User(login: "test_user", password: "test123", fullName: "Test User Debug", avatar: avatarImage, status: "This is a DEBUG test account")
        ]
    }
}
