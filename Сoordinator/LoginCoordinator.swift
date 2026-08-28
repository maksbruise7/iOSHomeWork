import UIKit

class LoginCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: ProfileCoordinator?
    
    init() {
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let loginVC = LogInViewController()
        loginVC.coordinator = self
        loginVC.loginDelegate = LoginInspector()
        loginVC.modalPresentationStyle = .fullScreen
        navigationController.setViewControllers([loginVC], animated: false)
    }
    
    func navigateToProfile(with user: User) {
        if let profileCoordinator = parentCoordinator {
            let userService = CurrentUserService(users: [user])
            let viewModel = ProfileViewModel(userService: userService, userLogin: user.login)
            if let profileVC = profileCoordinator.navigationController.viewControllers.first as? ProfileViewController {
                profileVC.viewModel = viewModel
            }
        }
        navigationController.dismiss(animated: true)
        parentCoordinator?.dismissLogin()
    }
}
