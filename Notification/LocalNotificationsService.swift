import UIKit
import UserNotifications

// MARK: - Local Notifications Service
class LocalNotificationsService: NSObject {
    
    // MARK: - Singleton
    static let shared = LocalNotificationsService()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    // MARK: - Public Methods
    
    /// Запрос разрешения и регистрация уведомлений
    func registerForLatestUpdatesIfPossible() {
        // 1. Запрашиваем разрешение
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            if let error = error {
                print("❌ Ошибка запроса разрешения: \(error.localizedDescription)")
                return
            }
            
            if granted {
                print("✅ Разрешение на уведомления получено")
                self?.scheduleDailyNotification()
            } else {
                print("⚠️ Разрешение на уведомления НЕ получено")
            }
        }
    }
    
    /// Проверка статуса разрешения
    func checkNotificationStatus(completion: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            let isAuthorized = settings.authorizationStatus == .authorized
            DispatchQueue.main.async {
                completion(isAuthorized)
            }
        }
    }
    
    /// Удаление всех запланированных уведомлений
    func removeAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        print("🗑️ Все уведомления удалены")
    }
    
    // MARK: - Private Methods
    
    /// Создание ежедневного уведомления на 19:00
    private func scheduleDailyNotification() {
        // 1. Создаем контент уведомления
        let content = UNMutableNotificationContent()
        content.title = "📱 ВКонтакте"
        content.body = "Посмотрите последние обновления"
        content.sound = .default
        content.badge = 1
        
        // 2. Создаем триггер на 19:00 каждый день
        var dateComponents = DateComponents()
        dateComponents.hour = 19
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )
        
        // 3. Создаем запрос на уведомление
        let request = UNNotificationRequest(
            identifier: "daily_update",
            content: content,
            trigger: trigger
        )
        
        // 4. Регистрируем уведомление
        notificationCenter.add(request) { error in
            if let error = error {
                print("❌ Ошибка регистрации уведомления: \(error.localizedDescription)")
            } else {
                print("✅ Ежедневное уведомление на 19:00 зарегистрировано")
            }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension LocalNotificationsService: UNUserNotificationCenterDelegate {
    
    /// Обработка уведомления, когда приложение активно
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Показываем уведомление даже когда приложение открыто
        completionHandler([.banner, .sound, .badge])
    }
    
    /// Обработка нажатия на уведомление
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        print("🔔 Пользователь нажал на уведомление")
        // Здесь можно обработать переход на определенный экран
        completionHandler()
    }
}
