import UIKit
import StorageService

class FeedCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init() {
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let feedVC = FeedViewController()
        feedVC.coordinator = self
        navigationController.setViewControllers([feedVC], animated: false)
    }
    
    func showPostViewController(with post: Post) {
        let postVC = PostViewController(post: post)
        postVC.coordinator = self
        navigationController.pushViewController(postVC, animated: true)
    }
    
    // Добавляем метод для показа InfoViewController
    func showInfoViewController() {
        let infoVC = InfoViewController()
        // Можно презентовать модально
        infoVC.modalPresentationStyle = .formSheet
        infoVC.modalTransitionStyle = .coverVertical
        navigationController.topViewController?.present(infoVC, animated: true)
    }
}
