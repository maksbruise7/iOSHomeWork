import XCTest
@testable import Navigation

// Mock для тестирования LoginViewModel
class MockLoginDelegate: LoginViewControllerDelegate {
    
    var shouldSucceed: Bool = true
    var calledCheckCredentials = false
    var calledSignUp = false
    
    func checkCredentials(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        calledCheckCredentials = true
        
        if shouldSucceed {
            let user = User(
                login: email,
                password: "",
                fullName: "Test User",
                avatar: UIImage(systemName: "person.circle") ?? UIImage(),
                status: "Active"
            )
            completion(.success(user))
        } else {
            let error = NSError(domain: "AuthError", code: 17009,
                              userInfo: [NSLocalizedDescriptionKey: "Неверный пароль"])
            completion(.failure(error))
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        calledSignUp = true
        
        if shouldSucceed {
            let user = User(
                login: email,
                password: "",
                fullName: "New User",
                avatar: UIImage(systemName: "person.circle") ?? UIImage(),
                status: "New User"
            )
            completion(.success(user))
        } else {
            let error = NSError(domain: "AuthError", code: 17007,
                              userInfo: [NSLocalizedDescriptionKey: "Email уже используется"])
            completion(.failure(error))
        }
    }
}

final class LoginViewModelTests: XCTestCase {
    
    var viewModel: LoginViewModel!
    var mockDelegate: MockLoginDelegate!
    
    override func setUp() {
        super.setUp()
        mockDelegate = MockLoginDelegate()
        viewModel = LoginViewModel(loginDelegate: mockDelegate)
    }
    
    override func tearDown() {
        viewModel = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    // MARK: - Тесты для валидации
    
    func testValidateEmail_WithValidEmail_ShouldReturnTrue() {
        // Arrange
        let validEmails = [
            "test@example.com",
            "user@mail.ru",
            "name@domain.org",
            "john.doe@company.co.uk"
        ]
        
        // Act & Assert
        for email in validEmails {
            XCTAssertTrue(viewModel.validateEmail(email), "Email '\(email)' должен быть валидным")
        }
    }
    
    func testValidateEmail_WithInvalidEmail_ShouldReturnFalse() {
        // Arrange
        let invalidEmails = [
            "test@example",
            "user@",
            "name",
            "@domain.com",
            "test@.com",
            "test@example.c"
        ]
        
        // Act & Assert
        for email in invalidEmails {
            XCTAssertFalse(viewModel.validateEmail(email), "Email '\(email)' должен быть НЕ валидным")
        }
    }
    
    func testValidatePassword_WithValidPassword_ShouldReturnTrue() {
        // Arrange
        let validPasswords = ["123456", "password", "Test123!", "abcdefgh"]
        
        // Act & Assert
        for password in validPasswords {
            XCTAssertTrue(viewModel.validatePassword(password), "Пароль '\(password)' должен быть валидным (>= 6 символов)")
        }
    }
    
    func testValidatePassword_WithInvalidPassword_ShouldReturnFalse() {
        // Arrange
        let invalidPasswords = ["", "123", "abc", "1"]
        
        // Act & Assert
        for password in invalidPasswords {
            XCTAssertFalse(viewModel.validatePassword(password), "Пароль '\(password)' должен быть НЕ валидным (< 6 символов)")
        }
    }
    
    // MARK: - Тесты для login
    
    func testLogin_WithValidCredentials_ShouldSucceed() {
        // Arrange
        mockDelegate.shouldSucceed = true
        viewModel.email = "test@example.com"
        viewModel.password = "test123"
        
        // Act
        let expectation = expectation(description: "Login completion")
        
        viewModel.login()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Assert
            XCTAssertTrue(self.viewModel.isLoginSuccess, "Логин должен быть успешным")
            XCTAssertNil(self.viewModel.errorMessage, "Сообщение об ошибке должно быть nil")
            XCTAssertFalse(self.viewModel.isLoading, "isLoading должен быть false")
            XCTAssertTrue(self.mockDelegate.calledCheckCredentials, "checkCredentials должен быть вызван")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLogin_WithInvalidCredentials_ShouldFail() {
        // Arrange
        mockDelegate.shouldSucceed = false
        viewModel.email = "test@example.com"
        viewModel.password = "wrongpassword"
        
        // Act
        let expectation = expectation(description: "Login completion")
        
        viewModel.login()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Assert
            XCTAssertFalse(self.viewModel.isLoginSuccess, "Логин должен быть НЕ успешным")
            XCTAssertNotNil(self.viewModel.errorMessage, "Сообщение об ошибке должно быть")
            XCTAssertFalse(self.viewModel.isLoading, "isLoading должен быть false")
            XCTAssertTrue(self.mockDelegate.calledCheckCredentials, "checkCredentials должен быть вызван")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLogin_WithEmptyFields_ShouldFailWithoutCallingDelegate() {
        // Arrange
        viewModel.email = ""
        viewModel.password = ""
        mockDelegate.calledCheckCredentials = false
        
        // Act
        viewModel.login()
        
        // Assert
        XCTAssertFalse(viewModel.isLoginSuccess, "Логин должен быть НЕ успешным")
        XCTAssertNotNil(viewModel.errorMessage, "Должно быть сообщение об ошибке")
        XCTAssertFalse(mockDelegate.calledCheckCredentials, "checkCredentials НЕ должен быть вызван")
    }
    
    func testLogin_WithInvalidEmail_ShouldFailWithoutCallingDelegate() {
        // Arrange
        viewModel.email = "invalid-email"
        viewModel.password = "test123"
        mockDelegate.calledCheckCredentials = false
        
        // Act
        viewModel.login()
        
        // Assert
        XCTAssertFalse(viewModel.isLoginSuccess, "Логин должен быть НЕ успешным")
        XCTAssertNotNil(viewModel.errorMessage, "Должно быть сообщение об ошибке")
        XCTAssertTrue(viewModel.errorMessage?.contains("email") ?? false, "Ошибка должна быть о email")
        XCTAssertFalse(mockDelegate.calledCheckCredentials, "checkCredentials НЕ должен быть вызван")
    }
    
    func testLogin_WithShortPassword_ShouldFailWithoutCallingDelegate() {
        // Arrange
        viewModel.email = "test@example.com"
        viewModel.password = "123"
        mockDelegate.calledCheckCredentials = false
        
        // Act
        viewModel.login()
        
        // Assert
        XCTAssertFalse(viewModel.isLoginSuccess, "Логин должен быть НЕ успешным")
        XCTAssertNotNil(viewModel.errorMessage, "Должно быть сообщение об ошибке")
        XCTAssertTrue(viewModel.errorMessage?.contains("6 символов") ?? false, "Ошибка должна быть о длине пароля")
        XCTAssertFalse(mockDelegate.calledCheckCredentials, "checkCredentials НЕ должен быть вызван")
    }
    
    // MARK: - Тест для reset
    
    func testReset_ShouldResetAllProperties() {
        // Arrange
        viewModel.email = "test@example.com"
        viewModel.password = "test123"
        viewModel.isLoading = true
        viewModel.errorMessage = "Some error"
        viewModel.isLoginSuccess = true
        
        // Act
        viewModel.reset()
        
        // Assert
        XCTAssertEqual(viewModel.email, "", "Email должен быть пустым")
        XCTAssertEqual(viewModel.password, "", "Password должен быть пустым")
        XCTAssertFalse(viewModel.isLoading, "isLoading должен быть false")
        XCTAssertNil(viewModel.errorMessage, "errorMessage должен быть nil")
        XCTAssertFalse(viewModel.isLoginSuccess, "isLoginSuccess должен быть false")
    }
}
