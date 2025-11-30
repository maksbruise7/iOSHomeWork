import UIKit

class ProfileViewController: UIViewController {
    
    
    private let imageAvatar = UIImageView()
    private let labelProfile = UILabel()
    private let labelAvatar = UILabel()
    private let button = UIButton()
    private let textStatus = UITextField()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = .lightGray
        
        let profileView = ProfileHeaderView()
        self.view.addSubview(profileView)
        
        
        func viewWillLayoutSubviews() {
            profileView.frame = self.view.frame
        }
        
        func setupImageAvatar() {
            imageAvatar.image = UIImage(named: "Avatar")
            imageAvatar.frame = CGRect(x: 16, y: 130, width: 150, height: 150)
            imageAvatar.layer.cornerRadius = imageAvatar.frame.size.width / 2
            imageAvatar.clipsToBounds = true
            imageAvatar.layer.borderColor = UIColor.white.cgColor
            imageAvatar.layer.borderWidth = 3
            view.addSubview(imageAvatar)
        }
        
        func setupLabelAvatar() {
            labelAvatar.frame = CGRect(x: 200, y: 157, width: 100, height: 20)
            labelAvatar.text = "Maksimka"
            labelAvatar.font = UIFont.systemFont(ofSize: 20)
            view.addSubview(labelAvatar)
        }
        
        func setupButton() {
            button.frame = CGRect(x: 16, y: 300, width: 370, height: 50)
            button.setTitle("Show status", for: .normal)
            button.backgroundColor = .blue
            button.layer.cornerRadius = 4
            button.setTitleColor(.white, for: .normal)
            button.addTarget(self,
                             action: #selector(tapped),
                             for: .touchUpInside
            )
            button.layer.masksToBounds = false
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 4, height: 4)
            button.layer.shadowRadius = 10
            button.layer.shadowOpacity = 0.7
            view.addSubview(button)
        }
        
        func setupTextStatus() {
            textStatus.frame = CGRect(x: 185, y: 225, width: 180, height: 25)
            textStatus.font = UIFont.systemFont(ofSize: 14)
            textStatus.textColor = .gray
            textStatus.placeholder = "Waiting for something..."
            textStatus.borderStyle = .roundedRect
            textStatus.layer.borderColor = UIColor.gray.cgColor
            textStatus.layer.borderWidth = 1.0
            view.addSubview(textStatus)
        }
    
        setupTextStatus()
        setupButton()
        setupLabelAvatar()
        setupImageAvatar()
    }
    
    @objc func tapped() {
        UIView.animate(withDuration: 0.2){
            self.button.backgroundColor = .black
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.17) {
            UIView.animate(withDuration: 0.2){
                self.button.backgroundColor = .blue
            }
        }
        if let text = textStatus.text {
            print("\(text)")
        }
    }
}
