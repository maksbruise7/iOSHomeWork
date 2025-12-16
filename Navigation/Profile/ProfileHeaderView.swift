import UIKit

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
        text.addTarget(self,
                       action: #selector(tapped),
                       for: .editingDidEnd
        )
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    // Кнопка для отправления статуса
    lazy var setStatusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show status", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 4
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.7
        button.addTarget(self,
                         action: #selector(tapped),
                         for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // Кнопка по заданию
    let myButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Моя кнопка", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(myButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 150),
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),
            
            fullNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            fullNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 185),
            fullNameLabel.widthAnchor.constraint(equalToConstant: 100),
            fullNameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            statusLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 95),
            statusLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 185),
            statusLabel.widthAnchor.constraint(equalToConstant: 180),
            statusLabel.heightAnchor.constraint(equalToConstant: 25),
            
            statusTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 125),
            statusTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 185),
            statusTextField.widthAnchor.constraint(equalToConstant: 180),
            statusTextField.heightAnchor.constraint(equalToConstant: 25),
            
            setStatusButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 182),
            setStatusButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            setStatusButton.heightAnchor.constraint(equalToConstant: 50),
            setStatusButton.widthAnchor.constraint(equalToConstant: 370),
            
            myButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 250),
            myButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 115),
            myButton.widthAnchor.constraint(equalToConstant: 180),
            myButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    @objc func tapped() {
           if let text = statusTextField.text {
               statusLabel.text = statusTextField.text
               print("\(text)")
           }
       }
   }

