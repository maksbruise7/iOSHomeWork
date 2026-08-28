import Foundation

// MARK: - App Configuration
enum AppConfiguration {
    case people(String)    // https://swapi.dev/api/people/{id}
    case starships(String) // https://swapi.dev/api/starships/{id}
    case planets(String)   // https://swapi.dev/api/planets/{id}
    
    // Получить URL из конфигурации
    var urlString: String {
        switch self {
        case .people(let id):
            return "https://swapi.dev/api/people/\(id)"
        case .starships(let id):
            return "https://swapi.dev/api/starships/\(id)"
        case .planets(let id):
            return "https://swapi.dev/api/planets/\(id)"
        }
    }
    
    var url: URL? {
        return URL(string: urlString)
    }
    
    // Описание для вывода
    var description: String {
        switch self {
        case .people:
            return "👤 People"
        case .starships:
            return "🚀 Starships"
        case .planets:
            return "🪐 Planets"
        }
    }
}

// MARK: - Random Configuration Generator
extension AppConfiguration {
    static func random() -> AppConfiguration {
        let configurations: [AppConfiguration] = [
            .people("8"),
            .starships("3"),
            .planets("5")
        ]
        return configurations.randomElement() ?? .people("1")
    }
}
