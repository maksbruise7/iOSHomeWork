import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    private let tabBarController: UITabBarController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        setupTabBar()
        setupCoordinators()
    }
    
    private func setupTabBar() {
        navigationController.setViewControllers([tabBarController], animated: false)
        navigationController.isNavigationBarHidden = true
    }
    
    private func setupCoordinators() {
        // Создаем координаторы для вкладок
        let feedCoordinator = FeedCoordinator()
        let profileCoordinator = ProfileCoordinator()
        
        childCoordinators.append(feedCoordinator)
        childCoordinators.append(profileCoordinator)
        
        // Получаем контроллеры от координаторов
        let feedNavController = feedCoordinator.navigationController
        let profileNavController = profileCoordinator.navigationController
        
        // Настраиваем TabBar иконки
        feedNavController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "Book"), tag: 0)
        profileNavController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "Horse"), tag: 1)
        
        // Добавляем в TabBarController
        tabBarController.viewControllers = [feedNavController, profileNavController]
        
        // Запускаем координаторы
        feedCoordinator.start()
        profileCoordinator.start()
    }
}
