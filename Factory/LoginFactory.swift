import Foundation

protocol LoginFactory {
    func makeLoginInspector() -> LoginViewControllerDelegate
}
