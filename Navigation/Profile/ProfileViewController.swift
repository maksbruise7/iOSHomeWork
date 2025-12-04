import UIKit

class ProfileViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = .lightGray
        
        let profileView = ProfileHeaderView()
        self.view.addSubview(profileView)
        
        
        func viewWillLayoutSubviews() {
            profileView.frame = self.view.frame
        }
        
        view.addSubview(profileView.textStatus)
        view.addSubview(profileView.button)
        view.addSubview(profileView.labelAvatar)
        view.addSubview(profileView.imageAvatar)
        view.addSubview(profileView.textAdd)
        
        profileView.setupTextAdd()
        profileView.setupTextStatus()
        profileView.setupImageAvatar()
        profileView.setupLabelAvatar()
        profileView.setupButton()
    }
}
