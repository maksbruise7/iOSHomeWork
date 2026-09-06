import UIKit
import StorageService
import UserNotifications
import Combine

class FeedViewController: UIViewController {
    
    // MARK: - Properties
    weak var coordinator: FeedCoordinator?
    private var viewModel: FeedViewModel!
    private var cancellables = Set<AnyCancellable>()  // ✅ Для подписок
    
    // MARK: - UI Components
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите загаданное слово"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray6
        textField.font = .systemFont(ofSize: 16)
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let checkGuessButton: CustomButton = {
        let button = CustomButton(
            title: "Проверить слово",
            titleColor: .white,
            backgroundColor: .systemBlue,
            font: .systemFont(ofSize: 16, weight: .semibold),
            cornerRadius: 10,
            height: 44
        )
        return button
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите слово и нажмите Проверить"
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let postButton: CustomButton = {
        let button = CustomButton(
            title: "Перейти к посту",
            titleColor: .white,
            backgroundColor: .systemGreen,
            font: .systemFont(ofSize: 16, weight: .semibold),
            cornerRadius: 10,
            height: 44
        )
        return button
    }()
    
    private let networkRequestButton: CustomButton = {
        let button = CustomButton(
            title: "Выполнить сетевой запрос",
            titleColor: .white,
            backgroundColor: .systemPurple,
            font: .systemFont(ofSize: 16, weight: .semibold),
            cornerRadius: 10,
            height: 44
        )
        return button
    }()
    
    private let testNotificationButton: CustomButton = {
        let button = CustomButton(
            title: "📢 Тест уведомления (через 5 сек)",
            titleColor: .white,
            backgroundColor: .systemOrange,
            font: .systemFont(ofSize: 16, weight: .semibold),
            cornerRadius: 10,
            height: 44
        )
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupView()
        setupActions()
        setupTextFieldDelegate()
        setupBindings()
        checkNotificationStatus()
    }
    
    // MARK: - Setup
    
    private func setupViewModel() {
        viewModel = FeedViewModel()
        print("🎮 Загаданное слово: \(viewModel.getSecretWord())")
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = "Feed"
        
        view.addSubview(textField)
        view.addSubview(checkGuessButton)
        view.addSubview(resultLabel)
        view.addSubview(postButton)
        view.addSubview(networkRequestButton)
        view.addSubview(testNotificationButton)
        
        setupConstraints()
    }
    
    private func setupActions() {
        // ✅ Используем ViewModel
        checkGuessButton.setAction { [weak self] in
            guard let text = self?.textField.text else { return }
            self?.viewModel.updateState(viewInput: .checkButtonDidTap(text: text))
        }
        
        postButton.setAction { [weak self] in
            self?.viewModel.updateState(viewInput: .pushButtonDidTap)
            let post = Post(title: "New Post")
            self?.coordinator?.showPostViewController(with: post)
        }
        
        networkRequestButton.setAction { [weak self] in
            self?.performNetworkRequest()
        }
        
        testNotificationButton.setAction { [weak self] in
            self?.testNotification()
        }
    }
    
    private func setupTextFieldDelegate() {
        textField.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 44),
            
            checkGuessButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            checkGuessButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            checkGuessButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            resultLabel.topAnchor.constraint(equalTo: checkGuessButton.bottomAnchor, constant: 30),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            postButton.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 30),
            postButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            postButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            networkRequestButton.topAnchor.constraint(equalTo: postButton.bottomAnchor, constant: 16),
            networkRequestButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            networkRequestButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            testNotificationButton.topAnchor.constraint(equalTo: networkRequestButton.bottomAnchor, constant: 16),
            testNotificationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            testNotificationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            testNotificationButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Bindings (Combine)
    
    private func setupBindings() {
        // ✅ Подписка на изменение сообщения
        viewModel.$resultMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.resultLabel.text = message
            }
            .store(in: &cancellables)
        
        // ✅ Подписка на изменение цвета
        viewModel.$resultColor
            .receive(on: DispatchQueue.main)
            .sink { [weak self] color in
                switch color {
                case "green":
                    self?.resultLabel.textColor = .systemGreen
                case "red":
                    self?.resultLabel.textColor = .systemRed
                case "orange":
                    self?.resultLabel.textColor = .orange
                case "blue":
                    self?.resultLabel.textColor = .systemBlue
                default:
                    self?.resultLabel.textColor = .darkGray
                }
            }
            .store(in: &cancellables)
        
        // ✅ Подписка на состояние (для анимаций)
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                if case .checked(let result) = state {
                    if result {
                        self?.showSuccessAnimation()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Network Request
    
    private func performNetworkRequest() {
        let config = AppConfiguration.random()
        resultLabel.text = "🔄 Выполняется запрос к \(config.description)..."
        resultLabel.textColor = .systemBlue
        NetworkService.request(for: config)
        resultLabel.text = "✅ Запрос выполнен! Смотрите консоль."
        resultLabel.textColor = .systemGreen
    }
    
    // MARK: - Notification Testing
    
    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            let status: String
            switch settings.authorizationStatus {
            case .authorized:
                status = "✅ Разрешены"
            case .denied:
                status = "❌ Запрещены"
            case .notDetermined:
                status = "⏳ Не определено"
            case .provisional:
                status = "⚠️ Временные"
            @unknown default:
                status = "❓ Неизвестно"
            }
            print("📱 Статус уведомлений: \(status)")
        }
    }
    
    private func testNotification() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            guard settings.authorizationStatus == .authorized else {
                DispatchQueue.main.async {
                    self?.resultLabel.text = "⚠️ Уведомления запрещены! Включите в настройках."
                    self?.resultLabel.textColor = .orange
                }
                return
            }
            
            let content = UNMutableNotificationContent()
            content.title = "📱 Тест уведомления"
            content.body = "Это тестовое уведомление! Приложение работает корректно. ✅"
            content.sound = .default
            content.badge = 1
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(
                identifier: "test_notification",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("❌ Ошибка: \(error.localizedDescription)")
                        self?.resultLabel.text = "❌ Ошибка: \(error.localizedDescription)"
                        self?.resultLabel.textColor = .red
                    } else {
                        print("✅ Тестовое уведомление запланировано через 5 секунд")
                        self?.resultLabel.text = "✅ Уведомление придет через 5 секунд!"
                        self?.resultLabel.textColor = .systemGreen
                    }
                }
            }
        }
    }
    
    // MARK: - Animations
    
    private func shakeTextField() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.5
        animation.values = [-10, 10, -8, 8, -5, 5, -2, 2, 0]
        textField.layer.add(animation, forKey: "shake")
    }
    
    private func showSuccessAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.resultLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.resultLabel.transform = .identity
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension FeedViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = textField.text else { return true }
        viewModel.updateState(viewInput: .checkButtonDidTap(text: text))
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
