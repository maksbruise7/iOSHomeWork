import UIKit

class LogInViewController: UIViewController{
    
    lazy var profileView: ProfileTableHederView = {
        let view = ProfileTableHederView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //Метод добавляет свойство для кнопки
    func tapped() {
        profileView.logInButton.addTarget(
            self,
            action: #selector(showProfile),
            for: .touchUpInside
        )
    }
    
    @objc func showProfile() {
        let showProfile = ProfileViewController()
        showProfile.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(showProfile, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(profileView)
        constraints()
        tapped()
        notification()
    }
    
    func notification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    @objc func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                profileView.scrollView.contentInset = contentInsets
                profileView.scrollView.scrollIndicatorInsets = contentInsets
            }
        }

        @objc func keyboardWillHide(notification: NSNotification) {
            profileView.scrollView.contentInset = .zero
            profileView.scrollView.scrollIndicatorInsets = .zero
        }
    
    func constraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            profileView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            profileView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            profileView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            profileView.heightAnchor.constraint(equalTo: safeArea.heightAnchor)
        ])
    }
}

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(
        _ logInAcccount: UITextField
    ) -> Bool {
        logInAcccount.resignFirstResponder()
        return true
    }
}

