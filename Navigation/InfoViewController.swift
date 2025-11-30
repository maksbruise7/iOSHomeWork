import UIKit

class InfoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = .systemPink
        
        let button = UIButton(type: .system)
        button.setTitle("Алерт", for: .normal)
        button.frame = CGRect(x: 150, y: 300, width: 100, height: 50)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 20
        button.titleLabel!.font = UIFont.systemFont(ofSize: 30)
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        view.addSubview(button)
        
        
    }
    
    @objc func tapped() {
        let alertController = UIAlertController(title: "Заголовок",
                                                message: "Сообщение",
                                                preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel){_ in
            print("Нажата кнопка Отмена")
        }
        
        let okAction = UIAlertAction(title: "ОК", style: .default) {_ in
            print("Нажата кнопка ОК")
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}


