import UIKit

class PhotosTableViewCell: UITableViewCell {
    
       //MARK: - Subviews
    let imageOne: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Image1")
        image.layer.cornerRadius = 6
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let imageTwo: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Image2")
        image.layer.cornerRadius = 6
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let imageThree: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Image3")
        image.layer.cornerRadius = 6
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let imageFour: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Image4")
        image.layer.cornerRadius = 6
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let label: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "Photos"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let аrrow: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "⭢"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setupView()
        setupSubviews()
        setupConstraints()
        }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Func
    func setupView() {
        contentView.backgroundColor = .white
    }
    func setupSubviews() {
        contentView.addSubview(label)
        contentView.addSubview(imageOne)
        contentView.addSubview(imageTwo)
        contentView.addSubview(imageThree)
        contentView.addSubview(imageFour)
        contentView.addSubview(аrrow)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            аrrow.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            аrrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            imageOne.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
            imageOne.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            imageOne.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            imageOne.heightAnchor.constraint(equalToConstant: 58),
            imageOne.widthAnchor.constraint(equalToConstant: 88),
            
            imageTwo.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
            imageTwo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            imageTwo.leadingAnchor.constraint(equalTo: imageOne.trailingAnchor, constant: 8),
            imageTwo.heightAnchor.constraint(equalToConstant: 58),
            imageTwo.widthAnchor.constraint(equalToConstant: 88),
            
            imageThree.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
            imageThree.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            imageThree.leadingAnchor.constraint(equalTo: imageTwo.trailingAnchor, constant: 8),
            imageThree.heightAnchor.constraint(equalToConstant: 58),
            imageThree.widthAnchor.constraint(equalToConstant: 88),
            
            imageFour.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
            imageFour.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            imageFour.leadingAnchor.constraint(equalTo: imageThree.trailingAnchor, constant: 8),
            imageFour.heightAnchor.constraint(equalToConstant: 58),
            imageFour.widthAnchor.constraint(equalToConstant: 88)
        ])
    }
    
}
