import UIKit

final class CustomButton: UIButton {
    
    // MARK: - Properties
    private var action: (() -> Void)?
    
    // MARK: - Initializers
    init(title: String,
         titleColor: UIColor = .white,
         backgroundColor: UIColor = .systemBlue,
         font: UIFont = .systemFont(ofSize: 16, weight: .medium),
         cornerRadius: CGFloat = 10,
         height: CGFloat = 44,
         action: (() -> Void)? = nil) {
        
        super.init(frame: .zero)
        
        self.action = action
        
        setupButton(title: title,
                    titleColor: titleColor,
                    backgroundColor: backgroundColor,
                    font: font,
                    cornerRadius: cornerRadius,
                    height: height)
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupButton(title: String,
                             titleColor: UIColor,
                             backgroundColor: UIColor,
                             font: UIFont,
                             cornerRadius: CGFloat,
                             height: CGFloat) {
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        titleLabel?.font = font
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    // MARK: - Actions
    @objc private func buttonTapped() {
        action?()
    }
    
    // MARK: - Public Methods
    func setAction(_ action: @escaping () -> Void) {
        self.action = action
    }
}
