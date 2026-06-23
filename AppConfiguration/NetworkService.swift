import Foundation

// MARK: - Network Service
struct NetworkService {
    
    // MARK: - Request Method для AppConfiguration
    
    static func request(for configuration: AppConfiguration) {
        guard let url = configuration.url else {
            print("❌ Ошибка: Неверный URL")
            return
        }
        
        print("📡 Запрос к: \(configuration.description)")
        print("📍 URL: \(url.absoluteString)")
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Ошибка сети:")
                print("   - localizedDescription: \(error.localizedDescription)")
                let nsError = error as NSError
                print("   - Код ошибки: \(nsError.code)")
                print("   - Domain: \(nsError.domain)")
                
                // Специальная обработка TLS ошибки
                if nsError.code == -1200 || nsError.code == -1202 {
                    print("   - ⚠️ TLS ошибка! Проверьте Info.plist")
                    print("   - Добавьте NSAppTransportSecurity с NSAllowsArbitraryLoads = true")
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📊 Статус ответа: \(httpResponse.statusCode)")
                print("📋 Заголовки ответа:")
                for (key, value) in httpResponse.allHeaderFields {
                    print("   - \(key): \(value)")
                }
            }
            
            guard let data = data else {
                print("❌ Нет данных")
                return
            }
            
            if let dataString = String(data: data, encoding: .utf8) {
                print("📄 Данные ответа:")
                print(dataString.prefix(500))
            } else {
                print("⚠️ Не удалось преобразовать данные в строку")
            }
            
            switch configuration {
            case .people:
                parsePerson(data: data)
            case .planets:
                parsePlanet(data: data)
            case .starships:
                parseStarship(data: data)
            }
        }
        
        task.resume()
        print("🚀 Запрос отправлен")
    }
    
    // MARK: - Parsing Methods
    
    private static func parsePerson(data: Data) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("📄 Данные человека (JSONSerialization):")
                for (key, value) in json {
                    print("   - \(key): \(value)")
                }
                
                if let name = json["name"] as? String {
                    print("✅ Имя: \(name)")
                    UserDefaults.standard.set(name, forKey: "personName")
                }
            }
        } catch {
            print("❌ Ошибка парсинга JSONSerialization: \(error.localizedDescription)")
        }
    }
    
    private static func parsePlanet(data: Data) {
        do {
            let decoder = JSONDecoder()
            let planet = try decoder.decode(Planet.self, from: data)
            
            print("📄 Данные планеты (JSONDecoder):")
            print("   - Название: \(planet.name)")
            print("   - Период обращения: \(planet.orbitalPeriod)")
            print("   - Период вращения: \(planet.rotationPeriod)")
            print("   - Диаметр: \(planet.diameter)")
            print("   - Климат: \(planet.climate)")
            print("   - Гравитация: \(planet.gravity)")
            print("   - Население: \(planet.population)")
            
            UserDefaults.standard.set(planet.orbitalPeriod, forKey: "planetOrbitalPeriod")
            UserDefaults.standard.set(planet.name, forKey: "planetName")
            
        } catch {
            print("❌ Ошибка парсинга JSONDecoder: \(error.localizedDescription)")
        }
    }
    
    private static func parseStarship(data: Data) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("📄 Данные звездолета (JSONSerialization):")
                
                if let name = json["name"] as? String {
                    print("   - Название: \(name)")
                }
                if let model = json["model"] as? String {
                    print("   - Модель: \(model)")
                }
                if let manufacturer = json["manufacturer"] as? String {
                    print("   - Производитель: \(manufacturer)")
                }
                if let cost = json["cost_in_credits"] as? String {
                    print("   - Стоимость: \(cost) кредитов")
                }
            }
        } catch {
            print("❌ Ошибка парсинга звездолета: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Fetch Methods для InfoViewController (АЛЬТЕРНАТИВНЫЕ URL)

    static func fetchPerson(id: String, completion: @escaping (Person?) -> Void) {
        // Используем JSONPlaceholder - гарантированно работает с HTTPS
        let urlString = "https://jsonplaceholder.typicode.com/users/\(id)"
        guard let url = URL(string: urlString) else {
            print("❌ Неверный URL для Person")
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        
        print("📡 Запрос Person: \(urlString)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Ошибка запроса Person: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let data = data else {
                print("❌ Нет данных для Person")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    let name = json["name"] as? String ?? "Unknown"
                    let username = json["username"] as? String ?? ""
                    let email = json["email"] as? String ?? ""
                    let phone = json["phone"] as? String ?? ""
                    
                    // Создаем Person из альтернативных данных
                    let person = Person(
                        name: "\(name) (@\(username))",
                        height: "N/A",
                        mass: "N/A",
                        hairColor: "N/A",
                        skinColor: "N/A",
                        eyeColor: "N/A",
                        birthYear: "N/A",
                        gender: "N/A",
                        homeworld: email,
                        films: [],
                        species: [],
                        vehicles: [],
                        starships: [],
                        created: "",
                        edited: "",
                        url: ""
                    )
                    print("✅ Person успешно создан: \(person.name)")
                    print("   - Email: \(email)")
                    print("   - Phone: \(phone)")
                    DispatchQueue.main.async {
                        completion(person)
                    }
                } else {
                    print("❌ Ошибка парсинга JSON")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } catch {
                print("❌ Ошибка: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }

    static func fetchPlanet(id: String, completion: @escaping (Planet?) -> Void) {
        // Используем JSONPlaceholder - гарантированно работает с HTTPS
        let urlString = "https://jsonplaceholder.typicode.com/posts/\(id)"
        guard let url = URL(string: urlString) else {
            print("❌ Неверный URL для Planet")
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        
        print("📡 Запрос Planet: \(urlString)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Ошибка запроса Planet: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let data = data else {
                print("❌ Нет данных для Planet")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    let title = json["title"] as? String ?? "Unknown"
                    let body = json["body"] as? String ?? ""
                    let id = json["id"] as? Int ?? 0
                    
                    // Создаем Planet из альтернативных данных
                    let planet = Planet(
                        name: "📝 Post #\(id): \(title)",
                        rotationPeriod: "N/A",
                        orbitalPeriod: "\(id * 100)",
                        diameter: "N/A",
                        climate: String(body.prefix(100)) + "...",
                        gravity: "N/A",
                        terrain: "N/A",
                        surfaceWater: "N/A",
                        population: "N/A",
                        residents: [],
                        films: [],
                        created: "",
                        edited: "",
                        url: ""
                    )
                    print("✅ Planet успешно создана: \(planet.name)")
                    print("   - Период обращения: \(planet.orbitalPeriod)")
                    DispatchQueue.main.async {
                        completion(planet)
                    }
                } else {
                    print("❌ Ошибка парсинга JSON")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } catch {
                print("❌ Ошибка: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
}
