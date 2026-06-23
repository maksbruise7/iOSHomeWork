import Foundation

protocol LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool
}
