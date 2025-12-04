import UIKit


class ProfileHeaderView: UIView {
 
    var imageAvatar = UIImageView()
    var labelProfile = UILabel()
    var labelAvatar = UILabel()
    var button = UIButton()
    var textStatus = UILabel()
    var textAdd = UITextField()
    
    //Кнопка к заданию
    let myButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Моя кнопка", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    func setupTextAdd() {
        textAdd.frame = CGRect(x: 185, y: 255, width: 180, height: 25)
        textAdd.font = UIFont.systemFont(ofSize: 15)
        textAdd.textColor = .black
        textAdd.placeholder = "Waiting for something..."
        textAdd.borderStyle = .roundedRect
        textAdd.layer.borderColor = UIColor.black.cgColor
        textAdd.layer.borderWidth = 1.0
        textAdd.backgroundColor = .white
        textAdd.layer.cornerRadius = 12
        textAdd.layer.masksToBounds = true
        textAdd.addTarget(self, action: #selector(tapped), for: .editingDidEnd)
    }
    
    func setupImageAvatar() {
        imageAvatar.image = UIImage(named: "Avatar")
        imageAvatar.frame = CGRect(x: 16, y: 130, width: 150, height: 150)
        imageAvatar.layer.cornerRadius = imageAvatar.frame.size.width / 2
        imageAvatar.clipsToBounds = true
        imageAvatar.layer.borderColor = UIColor.white.cgColor
        imageAvatar.layer.borderWidth = 3
    }
    
    func setupLabelAvatar() {
        labelAvatar.frame = CGRect(x: 200, y: 157, width: 100, height: 20)
        labelAvatar.text = "Hipster Cat"
        labelAvatar.font = UIFont.systemFont(ofSize: 20)
    }
    
    func setupButton() {
        button.frame = CGRect(x: 16, y: 300, width: 370, height: 50)
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
    }
    
    func setupTextStatus() {
        textStatus.frame = CGRect(x: 185, y: 225, width: 180, height: 25)
        textStatus.font = UIFont.systemFont(ofSize: 14)
        textStatus.textColor = .black
        textStatus.text = "Status"
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
        
        if let text = textAdd.text {
            textStatus.text = textAdd.text
            print("\(text)")
        }
    }
}


