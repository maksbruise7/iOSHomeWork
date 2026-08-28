import Foundation

class LoginInspector: LoginViewControllerDelegate {
    
    private let checkerService: CheckerServiceProtocol
    
    init(checkerService: CheckerServiceProtocol = CheckerService()) {
        self.checkerService = checkerService
    }
    
    func checkCredentials(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        checkerService.checkCredentials(email: email, password: password, completion: completion)
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        checkerService.signUp(email: email, password: password, completion: completion)
    }
}
