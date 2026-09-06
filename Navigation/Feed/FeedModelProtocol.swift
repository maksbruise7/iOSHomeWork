import Foundation

protocol FeedModelProtocol {
    func check(word: String) -> Bool
    func getSecretWord() -> String
}
