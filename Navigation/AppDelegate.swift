import UIKit
import FirebaseCore
import FirebaseAuth
import UserNotifications  

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Инициализация Firebase
        FirebaseApp.configure()
        print("✅ Firebase сконфигурирован")
        
        // ✅ Регистрация локальных уведомлений
        LocalNotificationsService.shared.registerForLatestUpdatesIfPossible()
        
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        do {
            try Auth.auth().signOut()
            print("👋 Пользователь вышел (applicationWillTerminate)")
        } catch {
            print("❌ Ошибка выхода: \(error.localizedDescription)")
        }
    }
}
