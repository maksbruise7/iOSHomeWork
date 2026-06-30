import UIKit

class ProfileCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init() {
        self.navigationController = UINavigationController()
        print("🏗️ ProfileCoordinator инициализирован")
    }
    
    func start() {
        print("▶️ ProfileCoordinator.start() вызван")
        
        #if DEBUG
        let users = DataProvider.getTestUsers()
        let userService: UserService = TestUserService(users: users)
        let userLogin = users.first?.login ?? "test_user"
        #else
        let users = DataProvider.getRealUsers()
        let userService: UserService = CurrentUserService(users: users)
        let userLogin = users.first?.login ?? "admin"
        #endif
        
        let viewModel = ProfileViewModel(userService: userService, userLogin: userLogin)
        let profileVC = ProfileViewController()
        profileVC.viewModel = viewModel
        profileVC.coordinator = self
        
        navigationController.setViewControllers([profileVC], animated: false)
        print("✅ ProfileViewController установлен в ProfileCoordinator")
    }
    
    func showLoginViewController() {
        print("📤 ProfileCoordinator.showLoginViewController вызван")
        let loginCoordinator = LoginCoordinator()
        loginCoordinator.parentCoordinator = self
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
        
        navigationController.topViewController?.present(loginCoordinator.navigationController, animated: true)
        print("✅ LoginCoordinator показан")
    }
    
    func showPhotosViewController() {
        print("📤 ProfileCoordinator.showPhotosViewController вызван")
        let photosVC = PhotosViewController()
        photosVC.coordinator = self
        navigationController.pushViewController(photosVC, animated: true)
        print("✅ PhotosViewController показан")
    }
    
    // НОВЫЙ МЕТОД для показа InfoViewController
    func showInfoViewController() {
        print("📤 ProfileCoordinator.showInfoViewController вызван")
        let infoVC = InfoViewController()
        infoVC.modalPresentationStyle = .formSheet
        infoVC.modalTransitionStyle = .coverVertical
        navigationController.topViewController?.present(infoVC, animated: true)
        print("✅ InfoViewController показан")
    }
    
    func dismissLogin() {
        if let loginCoordinator = childCoordinators.first(where: { $0 is LoginCoordinator }) {
            loginCoordinator.navigationController.dismiss(animated: true)
            childCoordinators.removeAll { $0 is LoginCoordinator }
            print("✅ LoginCoordinator удален")
        }
    }
    
    func logout() {
        print("📤 ProfileCoordinator.logout вызван")
        showLoginViewController()
    }
}
