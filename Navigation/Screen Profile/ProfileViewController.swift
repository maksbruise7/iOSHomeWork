import UIKit
import Combine
import SnapKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    weak var coordinator: ProfileCoordinator?
    var viewModel: ProfileViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    private let profileHeaderView = ProfileHeaderView()
    private let contentTable = PostArray.make()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotosCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 500
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
        setupActions()
        setupNavigationBar()
        viewModel.loadUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.tableHeaderView = profileHeaderView
        profileHeaderView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 250)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // Обновленная настройка навигационной панели
    private func setupNavigationBar() {
        navigationItem.title = "Profile"
        
        // Кнопка "Выйти" слева
        let logoutButton = UIBarButtonItem(
            title: "Выйти",
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
        logoutButton.tintColor = .systemRed
        navigationItem.leftBarButtonItem = logoutButton
        
        // Кнопка "Info" справа (НОВАЯ)
        let infoButton = UIBarButtonItem(
            title: "Info",
            style: .plain,
            target: self,
            action: #selector(showInfoViewController)
        )
        infoButton.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = infoButton
        
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Actions
    @objc private func logoutTapped() {
        let alert = UIAlertController(
            title: "Выход",
            message: "Вы уверены, что хотите выйти из аккаунта?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Выйти", style: .destructive) { [weak self] _ in
            self?.coordinator?.logout()
        })
        
        present(alert, animated: true)
    }
    
    @objc private func showInfoViewController() {
        // Используем координатор для перехода
        coordinator?.showInfoViewController()
    }
    
    private func setupBindings() {
        viewModel.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                guard let user = user else { return }
                self?.updateUI(with: user)
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.showAlert(message: error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$statusText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.profileHeaderView.statusLabel.text = status
            }
            .store(in: &cancellables)
    }
    
    private func setupActions() {
        profileHeaderView.setStatusButton.setAction { [weak self] in
            self?.updateStatus()
        }
    }
    
    private func updateUI(with user: User) {
        profileHeaderView.fullNameLabel.text = user.fullName
        profileHeaderView.statusLabel.text = user.status
        profileHeaderView.avatarImageView.image = user.avatar
        tableView.reloadData()
    }
    
    private func updateStatus() {
        guard let newStatus = profileHeaderView.statusTextField.text,
              !newStatus.isEmpty else {
            showAlert(message: "Введите статус")
            return
        }
        
        viewModel.updateStatus(newStatus)
        profileHeaderView.statusTextField.text = ""
        view.endEditing(true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return contentTable.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosCell", for: indexPath) as! PhotosTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
            cell.configure(with: contentTable[indexPath.row])
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            coordinator?.showPhotosViewController()
        }
    }
}
