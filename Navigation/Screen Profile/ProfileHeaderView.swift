import UIKit
import SnapKit

class ProfileHeaderView: UIView {
    
    
    // Аватар
    let avatarImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Avatar")
        image.layer.cornerRadius = 75
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 3
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // Имя профиля
    let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hipster Cat"
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Статус профиля
    let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "Status"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Ввод для статуса
    lazy var statusTextField: UITextField = {
        let text = UITextField()
        text.font = UIFont.systemFont(ofSize: 15)
        text.textColor = .black
        text.placeholder = "Waiting for something..."
        text.addTarget(
            self,
            action: #selector(tapped),
            for: .touchUpInside
        )
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    // Кнопка для отправления статуса
    lazy var setStatusButton: CustomButton = {
        let button = CustomButton(
            title: "Set Status",
            titleColor: .white,
            backgroundColor: .systemBlue,
            font: .systemFont(ofSize: 14, weight: .medium),
            cornerRadius: 8,
            height: 40,
            action: { [weak self] in
                self?.tapped()
            }
        )
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        addSubview()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubview() {
        addSubview(avatarImageView)
        addSubview(fullNameLabel)
        addSubview(statusLabel)
        addSubview(statusTextField)
        addSubview(setStatusButton)
    }
    
    func setupConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(150)
        }
        
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.equalToSuperview().offset(185)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(95)
            make.leading.equalToSuperview().offset(185)
            make.width.equalTo(180)
            make.height.equalTo(25)
        }
        
        statusTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(125)
            make.leading.equalToSuperview().offset(185)
            make.width.equalTo(180)
            make.height.equalTo(25)
        }
        
        setStatusButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(182)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(50)
            make.width.equalTo(370)
        }
    }
    
    @objc func tapped() {
           if let text = statusTextField.text {
               statusLabel.text = statusTextField.text
               print("\(text)")
           }
       }
    
    
   }

extension UITableView {
    func setAndLayout(headerView: UIView) {
        tableHeaderView = headerView
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        headerView.frame.size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
