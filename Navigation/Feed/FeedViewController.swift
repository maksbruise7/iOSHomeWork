import UIKit
import StorageService

class FeedViewController: UIViewController {
    
    // MARK: - Properties
    weak var coordinator: FeedCoordinator?
    private var feedModel: FeedModel!
    
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
    
    // Новая кнопка для сетевого запроса
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupModel()
        setupActions()
        setupTextFieldDelegate()
    }
    
    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = .white
        title = "Feed"
        
        view.addSubview(textField)
        view.addSubview(checkGuessButton)
        view.addSubview(resultLabel)
        view.addSubview(postButton)
        view.addSubview(networkRequestButton)
        
        setupConstraints()
    }
    
    private func setupModel() {
        feedModel = FeedModel(secretWord: "swift")
        print("🎮 Загаданное слово: \(feedModel.getSecretWord())")
    }
    
    private func setupActions() {
        checkGuessButton.setAction { [weak self] in
            self?.checkGuess()
        }
        
        postButton.setAction { [weak self] in
            let post = Post(title: "New Post")
            self?.coordinator?.showPostViewController(with: post)
        }
        
        networkRequestButton.setAction { [weak self] in
            self?.performNetworkRequest()
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
            networkRequestButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Game Logic
    private func checkGuess() {
        view.endEditing(true)
        
        guard let guessedText = textField.text, !guessedText.isEmpty else {
            showEmptyFieldWarning()
            return
        }
        
        let isCorrect = feedModel.check(word: guessedText)
        updateResultLabel(isCorrect: isCorrect, guessedWord: guessedText)
    }
    
    private func showEmptyFieldWarning() {
        resultLabel.text = "⚠️ Пожалуйста, введите слово!"
        resultLabel.textColor = .orange
        shakeTextField()
    }
    
    private func updateResultLabel(isCorrect: Bool, guessedWord: String) {
        if isCorrect {
            resultLabel.text = "✅ Правильно! Слово '\(guessedWord)' угадано!"
            resultLabel.textColor = .systemGreen
            showSuccessAnimation()
        } else {
            resultLabel.text = "❌ Неправильно! Слово '\(guessedWord)' не совпадает. Попробуйте еще раз!"
            resultLabel.textColor = .systemRed
            shakeTextField()
        }
    }
    
    // MARK: - Network Request
    private func performNetworkRequest() {
        // Создаем случайную конфигурацию
        let config = AppConfiguration.random()
        
        resultLabel.text = "🔄 Выполняется запрос к \(config.description)..."
        resultLabel.textColor = .systemBlue
        
        // Выполняем сетевой запрос
        NetworkService.request(for: config)
        
        resultLabel.text = "✅ Запрос выполнен! Смотрите консоль."
        resultLabel.textColor = .systemGreen
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
        checkGuess()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
