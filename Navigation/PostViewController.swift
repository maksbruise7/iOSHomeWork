import UIKit

struct Post {
    let title: String
}

class PostViewController: UIViewController {

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
        
        view.backgroundColor = .green
        title = post.title
        
        let play = UIBarButtonItem(title: "New controller ", style: .plain, target: self, action: #selector(clickPush))
        navigationItem.rightBarButtonItem = play
        

    }
    
    @objc func clickPush() {
        let next = InfoViewController()
        next.modalPresentationStyle = .formSheet
        next.modalTransitionStyle = .coverVertical
        present(next, animated: true, completion: nil)
     }
}
