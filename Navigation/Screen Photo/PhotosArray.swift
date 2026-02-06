import Foundation


struct PhotoArray {
    let image: String
}

extension PhotoArray {
    static func make() -> [PhotoArray] {
        [
            PhotoArray(image: "Image1"),
            PhotoArray(image: "Image2"),
            PhotoArray(image: "Image3"),
            PhotoArray(image: "Image4"),
            PhotoArray(image: "Image5"),
            PhotoArray(image: "Image6"),
            PhotoArray(image: "Image7"),
            PhotoArray(image: "Image1"),
            PhotoArray(image: "Image2"),
            PhotoArray(image: "Image3"),
            PhotoArray(image: "Image4"),
            PhotoArray(image: "Image5"),
            PhotoArray(image: "Image6"),
            PhotoArray(image: "Image7"),
            PhotoArray(image: "Image1"),
            PhotoArray(image: "Image2"),
            PhotoArray(image: "Image3"),
            PhotoArray(image: "Image4"),
            PhotoArray(image: "Image5"),
            PhotoArray(image: "Image6"),
        ]
    }
}
