import Foundation

// MARK: - Network Service
struct NetworkService {
    
    // MARK: - Static Methods
    static func request(for configuration: AppConfiguration) {
        guard let url = configuration.url else {
            print("❌ Ошибка: Неверный URL")
            return
        }
        
        print("📡 Запрос к: \(configuration.description)")
        print("📍 URL: \(url.absoluteString)")
        
        // Создаем сессию
        let session = URLSession.shared
        
        // Создаем задачу
        let task = session.dataTask(with: url) { data, response, error in
            // Проверяем ошибки
            if let error = error {
                print("❌ Ошибка сети:")
                print("   - localizedDescription: \(error.localizedDescription)")
                
                // Приводим к NSError для получения дополнительной информации
                let nsError = error as NSError
                print("   - Код ошибки: \(nsError.code)")
                print("   - Domain: \(nsError.domain)")
                print("   - debugDescription: \(nsError.debugDescription)")
                
                // Выводим userInfo для дополнительной информации
                if let userInfo = nsError.userInfo as? [String: Any] {
                    print("   - UserInfo:")
                    for (key, value) in userInfo {
                        print("       \(key): \(value)")
                    }
                }
                
                // Специальная обработка для отсутствия интернета
                if nsError.code == -1009 {
                    print("   - 📵 Нет подключения к интернету (код: -1009)")
                }
                return
            }
            
            // Проверяем ответ
            if let httpResponse = response as? HTTPURLResponse {
                print("📊 Статус ответа: \(httpResponse.statusCode)")
                
                // Выводим все заголовки
                print("📋 Заголовки ответа:")
                for (key, value) in httpResponse.allHeaderFields {
                    print("   - \(key): \(value)")
                }
            }
            
            // Проверяем данные
            if let data = data {
                if let dataString = String(data: data, encoding: .utf8) {
                    print("📄 Данные ответа:")
                    print(dataString.prefix(500)) // Выводим первые 500 символов
                } else {
                    print("⚠️ Не удалось преобразовать данные в строку")
                }
            }
        }
        
        // Запускаем задачу
        task.resume()
    }
}
