import XCTest
@testable import Navigation

// MARK: - Mock для тестов
class FeedModelMock: FeedModelProtocol {
    var fakeResult: Bool = true
    var fakeSecretWord: String = "swift"
    var checkCalled = false
    var lastCheckedWord: String?
    
    func check(word: String) -> Bool {
        checkCalled = true
        lastCheckedWord = word
        return fakeResult
    }
    
    func getSecretWord() -> String {
        return fakeSecretWord
    }
}

final class FeedViewModelTests: XCTestCase {
    
    var viewModel: FeedViewModel!
    var mockModel: FeedModelMock!
    
    override func setUp() {
        super.setUp()
        mockModel = FeedModelMock()
        viewModel = FeedViewModel(feedModel: mockModel)
    }
    
    override func tearDown() {
        viewModel = nil
        mockModel = nil
        super.tearDown()
    }
    
    // MARK: - Тест 1: Проверка успешного результата
    
    func testCheckGuess_WithCorrectWord_ShouldReturnSuccess() {
        // Arrange
        mockModel.fakeResult = true
        
        // Act
        viewModel.updateState(viewInput: .checkButtonDidTap(text: "swift"))  // ← ИСПРАВЛЕНО
        
        // Assert
        XCTAssertTrue(mockModel.checkCalled)
        XCTAssertEqual(mockModel.lastCheckedWord, "swift")
        XCTAssertTrue(viewModel.isWordGuessed)
        XCTAssertEqual(viewModel.resultColor, "green")
        XCTAssertTrue(viewModel.resultMessage.contains("Правильно"))
        
        if case .checked(let result) = viewModel.state {
            XCTAssertTrue(result)
        } else {
            XCTFail("Ожидалось состояние .checked, получено \(viewModel.state)")
        }
    }
    
    // MARK: - Тест 2: Проверка неуспешного результата
    
    func testCheckGuess_WithIncorrectWord_ShouldReturnFailure() {
        // Arrange
        mockModel.fakeResult = false
        
        // Act
        viewModel.updateState(viewInput: .checkButtonDidTap(text: "java"))  // ← ИСПРАВЛЕНО
        
        // Assert
        XCTAssertTrue(mockModel.checkCalled)
        XCTAssertEqual(mockModel.lastCheckedWord, "java")
        XCTAssertFalse(viewModel.isWordGuessed)
        XCTAssertEqual(viewModel.resultColor, "red")
        XCTAssertTrue(viewModel.resultMessage.contains("Неправильно"))
        
        if case .checked(let result) = viewModel.state {
            XCTAssertFalse(result)
        } else {
            XCTFail("Ожидалось состояние .checked, получено \(viewModel.state)")
        }
    }
    
    // MARK: - Тест 3: Проверка пустого слова
    
    func testCheckGuess_WithEmptyWord_ShouldReturnError() {
        // Arrange
        let emptyWord = ""
        
        // Act
        viewModel.updateState(viewInput: .checkButtonDidTap(text: emptyWord))  // ← ИСПРАВЛЕНО
        
        // Assert
        XCTAssertFalse(mockModel.checkCalled, "check не должен вызываться для пустого слова")
        XCTAssertFalse(viewModel.isWordGuessed)
        XCTAssertEqual(viewModel.resultColor, "orange")
        XCTAssertTrue(viewModel.resultMessage.contains("введите слово"))
        
        if case .error(let message) = viewModel.state {
            XCTAssertTrue(message.contains("введите слово"))
        } else {
            XCTFail("Ожидалось состояние .error, получено \(viewModel.state)")
        }
    }
    
    // MARK: - Тест 4: Проверка сброса игры
    
    func testResetGame_ShouldResetAllProperties() {
        // Arrange
        viewModel.updateState(viewInput: .checkButtonDidTap(text: "swift"))
        
        // Act
        viewModel.resetGame()
        
        // Assert
        XCTAssertEqual(viewModel.state, .idle)
        XCTAssertFalse(viewModel.isWordGuessed)
        XCTAssertEqual(viewModel.resultColor, "gray")
        XCTAssertEqual(viewModel.resultMessage, "Введите слово и нажмите Проверить")
    }
    
    // MARK: - Тест 5: Проверка getSecretWord
    
    func testGetSecretWord_ShouldReturnCorrectWord() {
        // Arrange
        mockModel.fakeSecretWord = "swift"
        
        // Act
        let secret = viewModel.getSecretWord()
        
        // Assert
        XCTAssertEqual(secret, "swift")
        XCTAssertEqual(secret, mockModel.fakeSecretWord)
    }
}
