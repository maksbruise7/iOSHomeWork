import UIKit
import StorageService

class FeedViewController: UIViewController {
    
    // MARK: - Properties
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
    
    // Существующая кнопка Post (заменяем на CustomButton)
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
        
        setupConstraints()
    }
    
    private func setupModel() {
        // Загаданное слово (можете изменить на любое другое)
        feedModel = FeedModel(secretWord: "swift")
        
        // Для отладки (можно убрать перед релизом)
        print("🎮 Загаданное слово: \(feedModel.getSecretWord())")
    }
    
    private func setupActions() {
        // Обработчик для кнопки проверки слова
        checkGuessButton.setAction { [weak self] in
            self?.checkGuess()
        }
        
        // Обработчик для кнопки перехода к посту
        postButton.setAction { [weak self] in
            self?.showPost()
        }
    }
    
    private func setupTextFieldDelegate() {
        textField.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Поле ввода
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 44),
            
            // Кнопка проверки слова
            checkGuessButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            checkGuessButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            checkGuessButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Лейбл с результатом
            resultLabel.topAnchor.constraint(equalTo: checkGuessButton.bottomAnchor, constant: 30),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Кнопка перехода к посту
            postButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            postButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            postButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Game Logic
    private func checkGuess() {
        // Скрываем клавиатуру
        view.endEditing(true)
        
        // Проверяем, что текст не пустой
        guard let guessedText = textField.text, !guessedText.isEmpty else {
            showEmptyFieldWarning()
            return
        }
        
        // Проверяем слово через модель
        let isCorrect = feedModel.check(word: guessedText)
        
        // Обновляем UI с результатом
        updateResultLabel(isCorrect: isCorrect, guessedWord: guessedText)
        
        // Очищаем поле для следующей попытки (опционально)
        // textField.text = ""
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
    
    // MARK: - Navigation
    @objc private func showPost() {
        let post = Post(title: "New Post")
        let postVC = PostViewController(post: post)
        navigationController?.pushViewController(postVC, animated: true)
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
