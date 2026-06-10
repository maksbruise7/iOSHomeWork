import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let imageOne = UIImage(named: "Book")
        let imageTwo = UIImage(named: "Horse")
        
        let tabbarController = UITabBarController()
        
        // MARK: - Feed Tab
        let feedVC = FeedViewController()
        let feedNavController = UINavigationController(rootViewController: feedVC)
        feedNavController.tabBarItem = UITabBarItem(title: "Feed", image: imageOne, tag: 0)
        
        // MARK: - Profile Tab (MVVM)
        #if DEBUG
        let users = DataProvider.getTestUsers()
        let userService: UserService = TestUserService(users: users)
        let userLogin = users.first?.login ?? "test_user"
        #else
        let users = DataProvider.getRealUsers()
        let userService: UserService = CurrentUserService(users: users)
        let userLogin = users.first?.login ?? "admin"
        #endif
        
        let profileViewModel = ProfileViewModel(userService: userService, userLogin: userLogin)
        let profileVC = ProfileViewController()
        profileVC.viewModel = profileViewModel
        
        let profileNavController = UINavigationController(rootViewController: profileVC)
        profileNavController.tabBarItem = UITabBarItem(title: "Profile", image: imageTwo, tag: 1)
        
        tabbarController.viewControllers = [feedNavController, profileNavController]
        
        window?.rootViewController = tabbarController
        window?.makeKeyAndVisible()
    }
}
