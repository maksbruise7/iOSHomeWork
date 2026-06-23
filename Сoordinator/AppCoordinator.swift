import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    private let tabBarController: UITabBarController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        print("🏗️ AppCoordinator инициализирован")
    }
    
    func start() {
        print("▶️ AppCoordinator.start() вызван")
        setupTabBar()
        setupCoordinators()
    }
    
    private func setupTabBar() {
        navigationController.setViewControllers([tabBarController], animated: false)
        navigationController.isNavigationBarHidden = true
        print("✅ TabBar настроен")
    }
    
    private func setupCoordinators() {
        let feedCoordinator = FeedCoordinator()
        let profileCoordinator = ProfileCoordinator()
        
        childCoordinators.append(feedCoordinator)
        childCoordinators.append(profileCoordinator)
        
        let feedNavController = feedCoordinator.navigationController
        let profileNavController = profileCoordinator.navigationController
        
        feedNavController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "Book"), tag: 0)
        profileNavController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "Horse"), tag: 1)
        
        tabBarController.viewControllers = [feedNavController, profileNavController]
        
        feedCoordinator.start()
        profileCoordinator.start()
        
        print("✅ Координаторы запущены")
        print("📊 Количество childCoordinators: \(childCoordinators.count)")
    }
}
