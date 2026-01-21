import UIKit

class PostTableViewCell: UITableViewCell {

    let author: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let descrip: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let likes: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let views: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        tuneView()
        setupView()
        constaints()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    
    func tuneView() {
        backgroundColor = .tertiarySystemBackground
        contentView.backgroundColor = .tertiarySystemBackground
        imageView?.image = UIImage()
        }
    
    func setupView() {
        contentView.addSubview(author)
        contentView.addSubview(image)
        contentView.addSubview(descrip)
        contentView.addSubview(likes)
        contentView.addSubview(views)
    }
    
    func constaints() {
        NSLayoutConstraint.activate([
            author.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            author.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            image.topAnchor.constraint(equalTo: author.bottomAnchor, constant: 12),
            image.heightAnchor.constraint(equalToConstant: 400),
            image.widthAnchor.constraint(equalToConstant: 410),
            
            descrip.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 16),
            descrip.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            likes.topAnchor.constraint(equalTo: descrip.bottomAnchor, constant: 16),
            likes.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            views.topAnchor.constraint(equalTo: descrip.bottomAnchor, constant: 16),
            views.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configurat(_ model: PostArray) {
        author.text = model.author
        image.image = UIImage(named: model.image)
        descrip.text = model.descrip
        likes.text = "Likes: \(String(model.likes))"
        views.text = "Views: \(String(model.views))"
    }
}
