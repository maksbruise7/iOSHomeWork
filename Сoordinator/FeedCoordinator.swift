import UIKit
import StorageService

class FeedCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init() {
        self.navigationController = UINavigationController()
        print("🏗️ FeedCoordinator инициализирован")
    }
    
    func start() {
        print("▶️ FeedCoordinator.start() вызван")
        let feedVC = FeedViewController()
        feedVC.coordinator = self
        navigationController.setViewControllers([feedVC], animated: false)
        print("✅ FeedViewController установлен")
    }
    
    func showPostViewController(with post: Post) {
        print("📤 showPostViewController вызван")
        let postVC = PostViewController(post: post)
        postVC.coordinator = self
        navigationController.pushViewController(postVC, animated: true)
        print("✅ PostViewController показан")
    }
    
    func showInfoViewController() {
        print("📤 showInfoViewController вызван")
        
        // Создаем InfoViewController
        let infoVC = InfoViewController()
        infoVC.modalPresentationStyle = .formSheet
        infoVC.modalTransitionStyle = .coverVertical
        
        // Показываем на topViewController
        if let topVC = navigationController.topViewController {
            print("🔍 topViewController: \(topVC)")
            topVC.present(infoVC, animated: true) {
                print("✅ InfoViewController показан")
            }
        } else {
            print("❌ Нет topViewController")
            // Альтернативный способ
            navigationController.present(infoVC, animated: true)
        }
    }
}
