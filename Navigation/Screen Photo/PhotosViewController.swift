import UIKit
import Combine

class PhotosViewController: UIViewController {
    
    // MARK: - Properties
    private var displayedPhotos: [UIImage] = [] // Храним UIImage напрямую
    private var cancellable: AnyCancellable?
    private let imagePublisherFacade = ImagePublisherFacade()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 120, height: 120)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(
            PhotosCollectionViewCell.self,
            forCellWithReuseIdentifier: ID.collectionView.rawValue
        )
        
        return collectionView
    }()
    
    enum ID: String {
        case collectionView = "CollectionView"
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Photo Gallery"
        setupSubview()
        setupConstraints()
        setupImageSubscription()
        startImagePublishing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancelSubscription()
    }
    
    // MARK: - Setup
    func setupSubview() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor)
        ])
    }
    
    // MARK: - Image Publisher Setup
    private func setupImageSubscription() {
        // Подписываемся на получение изображений от паблишера
        cancellable = imagePublisherFacade.imagePublisher
            .receive(on: DispatchQueue.main) // Переключаем на главный поток для UI
            .sink { [weak self] image in
                guard let self = self else { return }
                self.addImageToCollection(image)
            }
    }
    
    private func startImagePublishing() {
        // Запускаем публикацию изображений:
        // - задержка 0.5 секунды
        // - 20 повторений (больше 10, заполняем всю коллекцию)
        print("🚀 Запуск публикации 20 изображений с задержкой 0.5 сек")
        imagePublisherFacade.addImagesWithTimer(delay: 0.5, repeatCount: 20)
    }
    
    private func addImageToCollection(_ image: UIImage) {
        displayedPhotos.append(image)
        
        let indexPath = IndexPath(item: displayedPhotos.count - 1, section: 0)
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: [indexPath])
        }, completion: nil)
        
        print("📸 Добавлено фото #\(displayedPhotos.count)")
        
        // Прокручиваем к последнему добавленному фото
        if displayedPhotos.count > 0 {
            collectionView.scrollToItem(
                at: indexPath,
                at: .bottom,
                animated: true
            )
        }
    }
    
    private func cancelSubscription() {
        cancellable?.cancel()
        cancellable = nil
        print("🔴 Подписка на ImagePublisher отменена")
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedPhotos.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ID.collectionView.rawValue,
            for: indexPath
        ) as! PhotosCollectionViewCell
        
        // Используем новый метод setup(with:)
        cell.setup(with: displayedPhotos[indexPath.row])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PhotosViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Выбрано фото #\(indexPath.row + 1)")
        // Здесь можно добавить переход на детальный экран
    }
}
