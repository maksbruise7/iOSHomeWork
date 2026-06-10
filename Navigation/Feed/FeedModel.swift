import Foundation

class FeedModel {
    
    // MARK: - Properties
    private let secretWord: String
    
    // MARK: - Initializer
    init(secretWord: String) {
        self.secretWord = secretWord.lowercased()
    }
    
    // MARK: - Public Methods
    func check(word: String) -> Bool {
        let trimmedWord = word.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return trimmedWord == secretWord
    }
    
    // Для отладки
    func getSecretWord() -> String {
        return secretWord
    }
}
