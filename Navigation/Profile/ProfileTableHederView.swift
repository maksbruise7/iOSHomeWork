import UIKit

class ProfileTableHederView: UIView{
    
    //scrollView
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    //contentView
    let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .lightGray
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.layer.borderWidth = 0.5
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        stackView.spacing = 0.5
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview()
        setupConstraints()
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubview() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageVk)
        contentView.addSubview(stackView)
        contentView.addSubview(logInButton)
        stackView.addArrangedSubview(logInAcccount)
        stackView.addArrangedSubview(password)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView занимает всё пространство
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    //Vk
    let imageVk: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "VK")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    //Логин аккаунта
    let logInAcccount: UITextField = {
        let login = UITextField()
        login.textColor = .black
        login.font = .systemFont(ofSize: 16)
        login.placeholder = "  Email or phone"
        login.keyboardType = .emailAddress
        login.returnKeyType = .done
        login.autocapitalizationType = .none
        login.backgroundColor = .systemGray6
        login.translatesAutoresizingMaskIntoConstraints = false
        return login
    }()
    
    //Пароль аккаунта
    let password: UITextField = {
        let password = UITextField()
        password.textColor = .black
        password.font = .systemFont(ofSize: 16)
        password.placeholder = "  Password"
        password.keyboardType = .emailAddress
        password.returnKeyType = .done
        password.isSecureTextEntry = true
        password.autocapitalizationType = .none
        password.backgroundColor = .systemGray6
        password.translatesAutoresizingMaskIntoConstraints = false
        return password
    }()
    
    //Кнопка логина
    lazy var logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: "Color")
        button.layer.cornerRadius = 10
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupContent() {
        NSLayoutConstraint.activate([
            imageVk.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            imageVk.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageVk.widthAnchor.constraint(equalToConstant: 100),
            imageVk.heightAnchor.constraint(equalToConstant: 100),
            
            stackView.topAnchor.constraint(equalTo: imageVk.bottomAnchor, constant: 120),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 384),
            stackView.heightAnchor.constraint(equalToConstant: 100),
            
            logInButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            logInButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logInButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            logInButton.widthAnchor.constraint(equalToConstant: 384),
            logInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}


