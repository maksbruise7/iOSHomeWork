import Foundation

class FeedModel: FeedModelProtocol {
    
    private let secretWord: String
    
    init(secretWord: String = "swift") {
        self.secretWord = secretWord.lowercased()
    }
    
    func check(word: String) -> Bool {
        let trimmedWord = word.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return trimmedWord == secretWord
    }
    
    func getSecretWord() -> String {
        return secretWord
    }
}
