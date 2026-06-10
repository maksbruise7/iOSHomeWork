import UIKit
import Combine

class ImagePublisherFacade {
    
    // Паблишер, который будет отправлять UIImage
    let imagePublisher = PassthroughSubject<UIImage, Never>()
    
    private var timerCancellable: AnyCancellable?
    private let photoNames = (1...20).map { "Image\($0)" }
    
    func addImagesWithTimer(delay: TimeInterval, repeatCount: Int) {
        var currentIndex = 0
        
        timerCancellable = Timer.publish(every: delay, on: .main, in: .common)
            .autoconnect()
            .prefix(repeatCount)
            .sink { [weak self] _ in
                guard let self = self, currentIndex < self.photoNames.count else { return }
                
                // Загружаем изображение по имени или создаем заглушку
                let image = UIImage(named: self.photoNames[currentIndex]) ?? self.generatePlaceholder(index: currentIndex)
                self.imagePublisher.send(image)
                currentIndex += 1
                print("Отправлено изображение #\(currentIndex)")
            }
    }
    
    private func generatePlaceholder(index: Int) -> UIImage {
        let size = CGSize(width: 200, height: 200)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            UIColor.systemBlue.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
            
            let text = "\(index + 1)" as NSString
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 60),
                .foregroundColor: UIColor.white
            ]
            let textSize = text.size(withAttributes: attributes)
            text.draw(at: CGPoint(x: (size.width - textSize.width) / 2,
                                  y: (size.height - textSize.height) / 2),
                      withAttributes: attributes)
        }
    }
    
    func cancel() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
}
