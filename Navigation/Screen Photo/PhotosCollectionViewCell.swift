import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Subviews
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        setupSubviews()
        setupLayouts()
    }
    
    // MARK: - Private
    
    private func setupView() {
        contentView.backgroundColor = .green
        contentView.clipsToBounds = true
    }
    
    private func setupSubviews() {
        contentView.addSubview(imageView)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 120),
            imageView.widthAnchor.constraint(equalToConstant: 120)
               ])
    }
    
    // MARK: - Public
    
    func setup(_ profile: PhotoArray) {
        imageView.image = UIImage(named: profile.image)
    }
}
