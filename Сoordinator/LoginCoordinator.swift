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
        
        // Настройка зависимостей LoginViewController
        #if DEBUG
        let users = DataProvider.getTestUsers()
        let userService: UserService = TestUserService(users: users)
        #else
        let users = DataProvider.getRealUsers()
        let userService: UserService = CurrentUserService(users: users)
        #endif
        
        loginVC.userService = userService
        loginVC.loginDelegate = LoginInspector()
        loginVC.modalPresentationStyle = .fullScreen
        
        navigationController.setViewControllers([loginVC], animated: false)
    }
    
    func navigateToProfile(with user: User) {
        // Обновляем Profile через parentCoordinator
        if let profileCoordinator = parentCoordinator {
            // Создаем новый ViewModel для обновленного пользователя
            #if DEBUG
            let userService: UserService = TestUserService(users: [user])
            #else
            let userService: UserService = CurrentUserService(users: [user])
            #endif
            
            let viewModel = ProfileViewModel(userService: userService, userLogin: user.login)
            
            // Обновляем ProfileViewController
            if let profileVC = profileCoordinator.navigationController.viewControllers.first as? ProfileViewController {
                profileVC.viewModel = viewModel
            }
        }
        
        // Закрываем Login экран
        navigationController.dismiss(animated: true)
        parentCoordinator?.dismissLogin()
    }
}
