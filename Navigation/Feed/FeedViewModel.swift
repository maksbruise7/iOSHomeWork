import Foundation
import Combine

// MARK: - States
enum FeedState: Equatable { 
    case idle
    case checking
    case checked(result: Bool)
    case error(message: String)
    
    // Реализация Equatable для случая с ассоциированными значениями
    static func == (lhs: FeedState, rhs: FeedState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.checking, .checking):
            return true
        case (.checked(let lResult), .checked(let rResult)):
            return lResult == rResult
        case (.error(let lMessage), .error(let rMessage)):
            return lMessage == rMessage
        default:
            return false
        }
    }
}

// MARK: - View Input
enum FeedViewInput {
    case checkButtonDidTap(text: String)
    case pushButtonDidTap
}

// MARK: - View Model
class FeedViewModel {
    
    // MARK: - Published Properties
    @Published private(set) var state: FeedState = .idle
    @Published var resultMessage: String = "Введите слово и нажмите Проверить"
    @Published var resultColor: String = "gray"
    @Published var isWordGuessed: Bool = false
    
    // MARK: - Dependencies
    private let feedModel: FeedModelProtocol
    
    // MARK: - Initializer
    init(feedModel: FeedModelProtocol = FeedModel()) {
        self.feedModel = feedModel
    }
    
    // MARK: - Public Methods
    func updateState(viewInput: FeedViewInput) {
        switch viewInput {
        case .checkButtonDidTap(let text):
            state = .checking
            resultMessage = "🔄 Проверка..."
            resultColor = "blue"
            
            let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard !trimmedText.isEmpty else {
                state = .error(message: "Пожалуйста, введите слово")
                resultMessage = "⚠️ Пожалуйста, введите слово!"
                resultColor = "orange"
                isWordGuessed = false
                return
            }
            
            let isCorrect = feedModel.check(word: trimmedText)
            state = .checked(result: isCorrect)
            isWordGuessed = isCorrect
            
            if isCorrect {
                resultMessage = "✅ Правильно! Слово '\(trimmedText)' угадано!"
                resultColor = "green"
            } else {
                resultMessage = "❌ Неправильно! Слово '\(trimmedText)' не совпадает. Попробуйте еще раз!"
                resultColor = "red"
            }
            
        case .pushButtonDidTap:
            print("📤 Переход к посту")
        }
    }
    
    func resetGame() {
        state = .idle
        resultMessage = "Введите слово и нажмите Проверить"
        resultColor = "gray"
        isWordGuessed = false
    }
    
    func getSecretWord() -> String {
        return feedModel.getSecretWord()
    }
}
