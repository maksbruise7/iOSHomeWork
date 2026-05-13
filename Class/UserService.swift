import Foundation

protocol UserService {
    func getUser(byLogin login: String) -> User?
}
