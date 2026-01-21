import Foundation
import UIKit

struct PostArray {
    let author: String
    let image: String
    let descrip: String
    let likes: Int
    let views: Int
}

extension PostArray {
    static func make() -> [PostArray] {
        [
            PostArray(
                author: "car.Audi",
                image: "Audi",
                descrip: "Встречайте новинку",
                likes: 1234,
                views: 1400
            ),
            
            PostArray(
                author: "newgame",
                image: "Game",
                descrip: "Новые похвалы от игроков",
                likes: 340,
                views: 590
            ),
            
            PostArray(
                author: "fishing",
                image: "Fishing",
                descrip: "Рыбалка на реке, это уникально",
                likes: 400,
                views: 513
            ),
            
            PostArray(
                author: "football",
                image: "Football",
                descrip: "Данная игра вызвала авации",
                likes: 1345,
                views: 1900
            )
        ]
    }
}
