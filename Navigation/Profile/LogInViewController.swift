import UIKit

class LogInViewController: UIViewController{
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
        addSubbview()
        setupConstraints()
        setupContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           setupKeyboardObservers()
       }
       
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           removeKeyboardObservers()
       }
       
       @objc func willShowKeyboard(_ notification: NSNotification) {
           let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
           scrollView.contentInset.bottom += keyboardHeight ?? 0.0
       }
       
       @objc func willHideKeyboard(_ notification: NSNotification) {
           scrollView.contentInset.bottom = 0.0
       }
    
    private func setupKeyboardObservers() {
            let notificationCenter = NotificationCenter.default
            
            notificationCenter.addObserver(
                self,
                selector: #selector(self.willShowKeyboard(_:)),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
            
            notificationCenter.addObserver(
                self,
                selector: #selector(self.willHideKeyboard(_:)),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
        }
        
        private func removeKeyboardObservers() {
            let notificationCenter = NotificationCenter.default
            notificationCenter.removeObserver(self)
        }
    
    func addSubbview() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // ScrollView занимает всё пространство
            scrollView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setupContent() {
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
            login.font = UIFont.systemFont(ofSize: 16)
            login.placeholder = "Email or phone"
            login.borderStyle = .roundedRect
            login.keyboardType = .emailAddress
            login.returnKeyType = .done
            login.backgroundColor = .systemGray6
            login.autocapitalizationType = .none
            login.translatesAutoresizingMaskIntoConstraints = false
            return login
        }()
        //Пароль аккаунта
        let password: UITextField = {
            let login = UITextField()
            login.textColor = .black
            login.font = UIFont.systemFont(ofSize: 16)
            login.placeholder = "Password"
            login.borderStyle = .roundedRect
            login.keyboardType = .emailAddress
            login.returnKeyType = .done
            login.backgroundColor = .systemGray6
            login.isSecureTextEntry = true
            login.autocapitalizationType = .none
            login.translatesAutoresizingMaskIntoConstraints = false
            return login
        }()
        //Кнопка логина
        let logInButton: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor(named: "Color")
            button.layer.cornerRadius = 10
            button.setTitle("Log in", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.addTarget(self, action: #selector(showProfile), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        contentView.addSubview(imageVk)
        contentView.addSubview(logInAcccount)
        contentView.addSubview(password)
        contentView.addSubview(logInButton)
        
        NSLayoutConstraint.activate([
        imageVk.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
        imageVk.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        imageVk.widthAnchor.constraint(equalToConstant: 100),
        imageVk.heightAnchor.constraint(equalToConstant: 100),
        
        logInAcccount.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 340),
        logInAcccount.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        logInAcccount.widthAnchor.constraint(equalToConstant: 384),
        logInAcccount.heightAnchor.constraint(equalToConstant: 50),
        
        password.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 390),
        password.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        password.widthAnchor.constraint(equalToConstant: 384),
        password.heightAnchor.constraint(equalToConstant: 50),
        
        logInButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 456),
        logInButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        logInButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        logInButton.widthAnchor.constraint(equalToConstant: 384),
        logInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func showProfile() {
        let showProfile = ProfileViewController()
        navigationController?.pushViewController(showProfile, animated: true)
    }
    
}

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ logInAcccount: UITextField) -> Bool {
        logInAcccount.resignFirstResponder()
        return true
    }
}
