import UIKit
import Combine

class ProfileViewModel {
    
    // MARK: - Output (данные для View)
    @Published var user: User?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var statusText: String = ""
    
    // MARK: - Dependencies
    private let userService: UserService
    private var currentUserLogin: String?
    
    // MARK: - Initializer
    init(userService: UserService, userLogin: String) {
        self.userService = userService
        self.currentUserLogin = userLogin
    }
    
    // MARK: - Input (команды от View)
    func loadUser() {
        guard let login = currentUserLogin else {
            errorMessage = "Логин пользователя не указан"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            
            if let user = self.userService.getUser(byLogin: login) {
                self.user = user
                self.statusText = user.status
            } else {
                self.errorMessage = "Пользователь с логином '\(login)' не найден"
            }
            self.isLoading = false
        }
    }
    
    func updateStatus(_ newStatus: String) {
        guard !newStatus.isEmpty else { return }
        statusText = newStatus
        // Здесь можно добавить сохранение статуса в модель
        print("📝 Статус обновлен: \(newStatus)")
    }
    
    func refreshUser() {
        loadUser()
    }
}
