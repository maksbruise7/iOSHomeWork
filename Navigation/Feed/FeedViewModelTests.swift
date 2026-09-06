import XCTest
@testable import Navigation

final class FeedViewModelTests: XCTestCase {
    
    var viewModel: FeedViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = FeedViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Тесты для checkGuess
    
    func testCheckGuess_WithCorrectWord_ShouldReturnSuccess() {
        // Arrange
        let correctWord = "swift"
        
        // Act
        viewModel.checkGuess(guessedWord: correctWord)
        
        // Assert
        XCTAssertTrue(viewModel.isWordGuessed, "Правильное слово должно давать true")
        XCTAssertEqual(viewModel.resultColor, "green", "Цвет должен быть зеленым")
        XCTAssertTrue(viewModel.resultMessage.contains("Правильно"), "Сообщение должно содержать 'Правильно'")
    }
    
    func testCheckGuess_WithIncorrectWord_ShouldReturnFailure() {
        // Arrange
        let incorrectWord = "java"
        
        // Act
        viewModel.checkGuess(guessedWord: incorrectWord)
        
        // Assert
        XCTAssertFalse(viewModel.isWordGuessed, "Неправильное слово должно давать false")
        XCTAssertEqual(viewModel.resultColor, "red", "Цвет должен быть красным")
        XCTAssertTrue(viewModel.resultMessage.contains("Неправильно"), "Сообщение должно содержать 'Неправильно'")
    }
    
    func testCheckGuess_WithEmptyWord_ShouldReturnWarning() {
        // Arrange
        let emptyWord = ""
        
        // Act
        viewModel.checkGuess(guessedWord: emptyWord)
        
        // Assert
        XCTAssertFalse(viewModel.isWordGuessed, "Пустое слово не должно угадывать")
        XCTAssertEqual(viewModel.resultColor, "orange", "Цвет должен быть оранжевым")
        XCTAssertTrue(viewModel.resultMessage.contains("введите слово"), "Сообщение должно просить ввести слово")
    }
    
    func testCheckGuess_WithWhitespaceWord_ShouldTrimAndHandle() {
        // Arrange
        let wordWithSpaces = "  swift  "
        
        // Act
        viewModel.checkGuess(guessedWord: wordWithSpaces)
        
        // Assert
        XCTAssertTrue(viewModel.isWordGuessed, "Слово с пробелами должно быть обрезано и угадано")
        XCTAssertEqual(viewModel.resultColor, "green", "Цвет должен быть зеленым")
    }
    
    // MARK: - Тест для resetGame
    
    func testResetGame_ShouldResetAllProperties() {
        // Arrange
        viewModel.checkGuess(guessedWord: "wrong")
        viewModel.isWordGuessed = true
        viewModel.resultColor = "red"
        viewModel.resultMessage = "Some message"
        
        // Act
        viewModel.resetGame()
        
        // Assert
        XCTAssertFalse(viewModel.isWordGuessed, "isWordGuessed должен быть false")
        XCTAssertEqual(viewModel.resultColor, "gray", "Цвет должен быть серым")
        XCTAssertEqual(viewModel.resultMessage, "Введите слово и нажмите Проверить", "Сообщение должно быть начальным")
    }
    
    // MARK: - Тест для getSecretWord
    
    func testGetSecretWord_ShouldReturnCorrectWord() {
        // Arrange & Act
        let secret = viewModel.getSecretWord()
        
        // Assert
        XCTAssertEqual(secret, "swift", "Секретное слово должно быть 'swift'")
        XCTAssertFalse(secret.isEmpty, "Секретное слово не должно быть пустым")
    }
}
