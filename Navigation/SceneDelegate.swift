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
        
//      Настройка зависимостей
        
        #if DEBUG
        // Для DEBUG режима
        let testUsers = DataProvider.getTestUsers()
        let userService: UserService = TestUserService(users: testUsers)
        
//      Настраиваем Checker для первого тестового пользователя
        let testCredentials = DataProvider.getCheckerCredentials()
        Checker.shared.setup(login: testCredentials.login, password: testCredentials.password)
        
        print("📍 DEBUG режим: Загружено \(testUsers.count) тестовых пользователей")
        #else
        // Для RELEASE режима
        let realUsers = DataProvider.getRealUsers()
        let userService: UserService = CurrentUserService(users: realUsers)
        
        // Настраиваем Checker для первого реального пользователя
        let realCredentials = DataProvider.getCheckerCredentials()
        Checker.shared.setup(login: realCredentials.login, password: realCredentials.password)
        
        print("📍 RELEASE режим: Загружено \(realUsers.count) реальных пользователей")
        #endif
        
//      Создаем LoginViewController и внедряем зависимости
        let loginVC = LogInViewController()
        loginVC.userService = userService // Внедряем сервис пользователей
        
//      Используем фабрику для создания делегата
        let factory = MyLoginFactory()
        loginVC.loginDelegate = factory.makeLoginInspector()
        
        // Для DEBUG автоматически заполняем поля
        #if DEBUG
        if let firstUser = testUsers.first {
            loginVC.profileView.logInAccount.text = firstUser.login
            loginVC.profileView.password.text = firstUser.password
        }
        #endif
        
        // Устанавливаем LoginViewController как корневой для profileNavController
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
