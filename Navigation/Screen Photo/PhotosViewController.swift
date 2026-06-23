import UIKit
import Combine

class PhotosViewController: UIViewController {
    
    // MARK: - Properties
    weak var coordinator: ProfileCoordinator?  // Добавляем это свойство
    
    private var displayedPhotos: [UIImage] = []
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
            forCellWithReuseIdentifier: "PhotoCell"
        )
        
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Photo Gallery"
        setupViews()
        setupImageSubscription()
        startImagePublishing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancelSubscription()
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.dataSource = self
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupImageSubscription() {
        cancellable = imagePublisherFacade.imagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.addImageToCollection(image)
            }
    }
    
    private func startImagePublishing() {
        imagePublisherFacade.addImagesWithTimer(delay: 0.5, repeatCount: 20)
    }
    
    private func addImageToCollection(_ image: UIImage) {
        displayedPhotos.append(image)
        
        let indexPath = IndexPath(item: displayedPhotos.count - 1, section: 0)
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: [indexPath])
        }, completion: nil)
        
        print("📸 Добавлено фото #\(displayedPhotos.count)")
        
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
        print("🔴 Подписка на ImagePublisher отменена")
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotosCollectionViewCell
        cell.setup(with: displayedPhotos[indexPath.row])
        return cell
    }
}
