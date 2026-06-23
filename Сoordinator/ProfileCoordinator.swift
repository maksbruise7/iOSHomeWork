import UIKit

class ProfileCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init() {
        self.navigationController = UINavigationController()
    }
    
    func start() {
        // Создаем и настраиваем ViewModel для Profile
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
    }
    
    func showLoginViewController() {
        let loginCoordinator = LoginCoordinator()
        loginCoordinator.parentCoordinator = self
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
        
        // Используем созданный loginCoordinator для презентации
        navigationController.topViewController?.present(loginCoordinator.navigationController, animated: true)
    }
    
    func showPhotosViewController() {
        let photosVC = PhotosViewController()
        photosVC.coordinator = self
        navigationController.pushViewController(photosVC, animated: true)
    }
    
    func dismissLogin() {
        if let loginCoordinator = childCoordinators.first(where: { $0 is LoginCoordinator }) {
            // Закрываем LoginCoordinator
            loginCoordinator.navigationController.dismiss(animated: true)
            childCoordinators.removeAll { $0 is LoginCoordinator }
        }
    }
    
    func logout() {
        // Показываем Login экран при выходе
        showLoginViewController()
    }
}
