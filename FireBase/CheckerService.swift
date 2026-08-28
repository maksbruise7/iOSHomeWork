import Foundation
import FirebaseAuth

class CheckerService: CheckerServiceProtocol {
    
    func checkCredentials(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("📡 Firebase signIn: \(trimmedEmail)")
        
        Auth.auth().signIn(withEmail: trimmedEmail, password: trimmedPassword) { authResult, error in
            if let error = error {
                let nsError = error as NSError
                print("❌ Ошибка входа, код: \(nsError.code)")
                
                if nsError.code == 17011 {
                    print("📝 Пользователь не найден, регистрируем...")
                    self.signUp(email: trimmedEmail, password: trimmedPassword, completion: completion)
                    return
                }
                
                if nsError.code == 17004 || nsError.code == 17000 {
                    let userError = NSError(
                        domain: "AuthError",
                        code: nsError.code,
                        userInfo: [NSLocalizedDescriptionKey: "Неверный формат email или пароля. Проверьте введенные данные."]
                    )
                    completion(.failure(userError))
                    return
                }
                
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = authResult?.user else {
                let error = NSError(domain: "AuthError", code: 1002,
                                  userInfo: [NSLocalizedDescriptionKey: "Не удалось получить данные пользователя"])
                completion(.failure(error))
                return
            }
            
            print("✅ Успешный вход: \(firebaseUser.email ?? "")")
            
            let user = User(
                login: firebaseUser.email ?? "",
                password: "",
                fullName: firebaseUser.displayName ?? "User",
                avatar: UIImage(systemName: "person.circle") ?? UIImage(),
                status: "Active"
            )
            completion(.success(user))
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("📡 Firebase createUser: \(trimmedEmail)")
        
        Auth.auth().createUser(withEmail: trimmedEmail, password: trimmedPassword) { authResult, error in
            if let error = error {
                let nsError = error as NSError
                print("❌ Ошибка регистрации, код: \(nsError.code)")
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = authResult?.user else {
                let error = NSError(domain: "AuthError", code: 1002,
                                  userInfo: [NSLocalizedDescriptionKey: "Не удалось создать пользователя"])
                completion(.failure(error))
                return
            }
            
            print("✅ Успешная регистрация: \(firebaseUser.email ?? "")")
            
            let user = User(
                login: firebaseUser.email ?? "",
                password: "",
                fullName: "User",
                avatar: UIImage(systemName: "person.circle") ?? UIImage(),
                status: "New User"
            )
            completion(.success(user))
        }
    }
}
