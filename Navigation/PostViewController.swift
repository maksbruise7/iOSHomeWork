import UIKit
import StorageService

class PostViewController: UIViewController {
    
    // MARK: - Properties
    weak var coordinator: FeedCoordinator?  // Добавляем координатор
    var post: Post
    
    // MARK: - Initialization
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }
    
    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = .white
        title = post.title
        
        // Добавляем информацию о посте
        let postLabel = UILabel()
        postLabel.text = post.title
        postLabel.font = .systemFont(ofSize: 24, weight: .bold)
        postLabel.textAlignment = .center
        postLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Описание поста: \(post.title)"
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(postLabel)
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            postLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            postLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            postLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            postLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: postLabel.bottomAnchor, constant: 20),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupNavigationBar() {
        // Кнопка для открытия InfoViewController (используем координатор)
        let infoButton = UIBarButtonItem(
            title: "Info",
            style: .plain,
            target: self,
            action: #selector(showInfoViewController)
        )
        navigationItem.rightBarButtonItem = infoButton
        
        // Кнопка назад
        let backButton = UIBarButtonItem(
            title: "Назад",
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationItem.leftBarButtonItem = backButton
    }
    
    // MARK: - Actions
    @objc private func showInfoViewController() {
        // Используем координатор для навигации
        coordinator?.showInfoViewController()
    }
    
    @objc private func goBack() {
        // Возвращаемся на предыдущий экран
        navigationController?.popViewController(animated: true)
    }
}
