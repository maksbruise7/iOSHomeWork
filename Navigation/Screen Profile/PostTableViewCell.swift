import UIKit
import iOSIntPackage

class PostTableViewCell: UITableViewCell {
    
    let author: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let postImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .black
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let descrip: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let likes: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let views: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        author.text = nil
        descrip.text = nil
        likes.text = nil
        views.text = nil
        postImageView.image = nil
    }
    
    func setupView() {
        contentView.addSubview(author)
        contentView.addSubview(postImageView)
        contentView.addSubview(descrip)
        contentView.addSubview(likes)
        contentView.addSubview(views)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // Автор
            author.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            author.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            author.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Изображение
            postImageView.topAnchor.constraint(equalTo: author.bottomAnchor, constant: 12),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor),
            
            // Описание
            descrip.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 16),
            descrip.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descrip.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Лайки
            likes.topAnchor.constraint(equalTo: descrip.bottomAnchor, constant: 16),
            likes.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            likes.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            // Просмотры
            views.topAnchor.constraint(equalTo: descrip.bottomAnchor, constant: 16),
            views.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            views.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    // Метод для конфигурации с вашей моделью PostArray
    func configure(with post: PostArray) {
        author.text = post.author
        descrip.text = post.descrip
        likes.text = "❤️ \(post.likes)"
        views.text = "👁️ \(post.views)"
        
        // Загружаем изображение
        if let sourceImage = UIImage(named: post.image) {
            applyFilter(to: sourceImage)
        } else {
            // Если изображения нет, создаем заглушку
            postImageView.image = generatePlaceholder(text: post.author)
        }
    }
    
    // Применение фильтра к изображению
    private func applyFilter(to image: UIImage) {
        let processor = ImageProcessor()
        
        processor.processImage(sourceImage: image, filter: .colorInvert) { [weak self] processedImage in
            DispatchQueue.main.async {
                self?.postImageView.image = processedImage ?? image
            }
        }
    }
    
    // Генерация изображения-заглушки
    private func generatePlaceholder(text: String) -> UIImage {
        let size = CGSize(width: 400, height: 400)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            UIColor.systemGray5.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24),
                .foregroundColor: UIColor.darkGray
            ]
            let textString = text as NSString
            let textSize = textString.size(withAttributes: attributes)
            textString.draw(at: CGPoint(x: (size.width - textSize.width) / 2,
                                        y: (size.height - textSize.height) / 2),
                           withAttributes: attributes)
        }
    }
}
