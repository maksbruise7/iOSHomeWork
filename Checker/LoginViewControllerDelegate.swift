import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func check(login: String, password: String) -> Bool
}
