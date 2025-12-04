import UIKit

class ProfileViewController: UIViewController {

    lazy var profileView: ProfileHeaderView = {
        let view = ProfileHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = .lightGray
        
        view.addSubview(profileView)
        view.addSubview(profileView.myButton)
        view.addSubview(profileView.textStatus)
        view.addSubview(profileView.button)
        view.addSubview(profileView.labelAvatar)
        view.addSubview(profileView.imageAvatar)
        view.addSubview(profileView.textAdd)
        
        setupContraints()
        
        setupButtonConstraints()
        profileView.setupTextAdd()
        profileView.setupTextStatus()
        profileView.setupImageAvatar()
        profileView.setupLabelAvatar()
        profileView.setupButton()
    }
    func setupButtonConstraints() {
        NSLayoutConstraint.activate([
            profileView.myButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            profileView.myButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            profileView.myButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    func setupContraints() {
       let safeArea = view.safeAreaLayoutGuide
       NSLayoutConstraint.activate([
           safeArea.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
           safeArea.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
           safeArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           safeArea.heightAnchor.constraint(equalToConstant: 220)
       ])
   }
}
