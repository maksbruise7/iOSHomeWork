import UIKit

// MARK: - Data Provider
struct DataProvider {
    
//      Реальные пользователи для Release
    static func getRealUsers() -> [User] {
        return [
            User(
                login: "admin",
                password: "password123",
                fullName: "Hipster Cat",
                avatar: UIImage(named: "Avatar") ?? UIImage(systemName: "person.circle.fill") ?? UIImage(),
                status: "Waiting for something..."
            ),
//      Можно добавить больше реальных пользователей
            User(
                login: "john_doe",
                password: "john123",
                fullName: "John Doe",
                avatar: UIImage(systemName: "person.circle") ?? UIImage(),
                status: "Hello, I'm John!"
            ),
            User(
                login: "jane_smith",
                password: "jane123",
                fullName: "Jane Smith",
                avatar: UIImage(systemName: "person.circle") ?? UIImage(),
                status: "Swift developer"
            )
        ]
    }
    
//      Тестовые пользователи для Debug
    static func getTestUsers() -> [User] {
        return [
            User(
                login: "test_user",
                password: "test123",
                fullName: "Test User Debug",
                avatar: UIImage(systemName: "person.circle.fill") ?? UIImage(),
                status: "This is a DEBUG test account"
            ),
//      Можно добавить больше тестовых пользователей
            User(
                login: "debug_user",
                password: "debug123",
                fullName: "Debug Master",
                avatar: UIImage(systemName: "person.circle") ?? UIImage(),
                status: "Testing in progress..."
            )
        ]
    }
    
//      Получить данные для проверки в Checker
    static func getCheckerCredentials() -> (login: String, password: String) {
        #if DEBUG
        // Для DEBUG используем первого тестового пользователя
        let testUsers = getTestUsers()
        return (testUsers[0].login, testUsers[0].password)
        #else
        // Для RELEASE используем первого реального пользователя
        let realUsers = getRealUsers()
        return (realUsers[0].login, realUsers[0].password)
        #endif
    }
}
