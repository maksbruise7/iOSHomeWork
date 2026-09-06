import Foundation
import Combine

class FeedViewModel {
    
    // MARK: - Published Properties
    @Published var secretWord: String = "swift"
    @Published var resultMessage: String = "Введите слово и нажмите Проверить"
    @Published var resultColor: String = "gray" // "gray", "green", "red"
    @Published var isWordGuessed: Bool = false
    
    // MARK: - Public Methods
    func checkGuess(guessedWord: String) {
        let trimmedWord = guessedWord.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        guard !trimmedWord.isEmpty else {
            resultMessage = "⚠️ Пожалуйста, введите слово!"
            resultColor = "orange"
            isWordGuessed = false
            return
        }
        
        if trimmedWord == secretWord.lowercased() {
            resultMessage = "✅ Правильно! Слово '\(guessedWord)' угадано!"
            resultColor = "green"
            isWordGuessed = true
        } else {
            resultMessage = "❌ Неправильно! Слово '\(guessedWord)' не совпадает. Попробуйте еще раз!"
            resultColor = "red"
            isWordGuessed = false
        }
    }
    
    func resetGame() {
        resultMessage = "Введите слово и нажмите Проверить"
        resultColor = "gray"
        isWordGuessed = false
    }
    
    func getSecretWord() -> String {
        return secretWord
    }
}
