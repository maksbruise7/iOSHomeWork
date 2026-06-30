import UIKit
import StorageService

class PostViewController: UIViewController {
    
    weak var coordinator: FeedCoordinator?
    var post: Post
    
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = post.title
        
        let infoButton = UIBarButtonItem(
            title: "Info",
            style: .plain,
            target: self,
            action: #selector(showInfoViewController)
        )
        navigationItem.rightBarButtonItem = infoButton
    }
    
    @objc func showInfoViewController() {
        coordinator?.showInfoViewController()
    }
}
