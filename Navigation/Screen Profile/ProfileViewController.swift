import UIKit

class ProfileViewController: UIViewController {
    
    var user: User?

    let contentTable = PostArray.make()
    
    enum ID: String {
        case postTableViewCell = "PostTableViewCell"
        case photosTableViewCell = "PhotosTableViewCell"//
    }
    
    private lazy var tableView:  UITableView = {
        let tableView = UITableView.init(
            frame: .zero,
            style: .plain
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstrains()
        tuneTableView()
        setupProfileData()
    }

    // Элементы UI 
    private let profileHeaderView = ProfileHeaderView()
    
    private func setupProfileData() {
        guard let user = user else { return }
        profileHeaderView.fullNameLabel.text = user.fullName
        profileHeaderView.statusLabel.text = user.status
        profileHeaderView.avatarImageView.image = user.avatar
    }
    
    
    func setupView() {
#if DEBUG
    // Цвет для Debug (например, чтобы сразу видеть, что это тестовая сборка)
    view.backgroundColor = .systemYellow
    #else
    // Цвет для Release
    view.backgroundColor = .systemBackground
    #endif
//        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func setupConstrains() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
        ])
    }
    
    func tuneTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: ID.postTableViewCell.rawValue)
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: ID.photosTableViewCell.rawValue)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
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
            let cell = tableView.dequeueReusableCell(withIdentifier: ID.photosTableViewCell.rawValue, for: indexPath) 
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ID.postTableViewCell.rawValue, for: indexPath) as! PostTableViewCell
            cell.configurat(contentTable[indexPath.row])
            return cell
            }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return profileHeaderView
        } else {
            return nil
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 125
        } else {
            return 550
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 250
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = PhotosViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate {}
