import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appConfiguration: AppConfiguration?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 🔑 Рандомно инициализируем конфигурацию
        appConfiguration = AppConfiguration.random()
        
        print("🏗️ Приложение запущено с конфигурацией: \(appConfiguration?.description ?? "неизвестно")")
        print("🔗 URL: \(appConfiguration?.urlString ?? "неизвестно")")
        
        // Вызываем сетевой запрос
        if let config = appConfiguration {
            NetworkService.request(for: config)
        }
        
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        
        // Создаем и запускаем AppCoordinator
        let appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator.start()
        
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}
