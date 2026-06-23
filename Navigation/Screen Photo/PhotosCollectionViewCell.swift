import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Subviews
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupSubviews()
        setupLayouts()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // MARK: - Private
    
    private func setupView() {
        contentView.backgroundColor = .systemGray6
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 8
    }
    
    private func setupSubviews() {
        contentView.addSubview(imageView)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            // Растягиваем imageView на весь contentView
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    // MARK: - Public
    
    // Метод для установки UIImage (новый)
    func setup(with image: UIImage) {
        imageView.image = image
    }
    
    // Метод для установки PhotoArray (оставляем для совместимости)
    func setup(_ profile: PhotoArray) {
        imageView.image = UIImage(named: profile.image)
    }
}
