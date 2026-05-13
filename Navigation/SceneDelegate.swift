import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        let imageOne = UIImage(named: "Book")
        let imageTwo = UIImage(named: "Horse")
        
        let tabbarController = UITabBarController()
        let feedNavController = UINavigationController()
        let profileNavController = UINavigationController()
        
        feedNavController.tabBarItem = UITabBarItem(title: "Feed", image: imageOne, tag: 0)
        profileNavController.tabBarItem = UITabBarItem(title: "Profile", image: imageTwo, tag: 1)
        
//      Создаем LoginViewController
        let loginVC = LogInViewController()
        
//      Используем фабрику для создания делегата
        let factory = MyLoginFactory()
        loginVC.loginDelegate = factory.makeLoginInspector()
        
//      Устанавливаем LoginViewController как корневой для profileNavController
        profileNavController.viewControllers = [loginVC]
        feedNavController.viewControllers = [FeedViewController()]
        
        tabbarController.viewControllers = [profileNavController, feedNavController]
        
        window?.rootViewController = tabbarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
