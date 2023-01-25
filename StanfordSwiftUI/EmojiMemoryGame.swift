//
//  EmojiMemoryGame.swift
//  StanfordSwiftUI
//
//  Created by 양호준 on 2023/01/19.
//

import SwiftUI

// 뷰 모델의 역할을 함
final class EmojiMemoryGame: ObservableObject { // 변경될 수 있음을 보여줌
    typealias Card = MemoryGame<String>.Card
    
    private static let emojis = [
        "🚕", "🚔", "🚁", "✈️", "🛺",
        "🚇", "🚀", "🛰", "🛳", "🏍",
        "🛸", "🚢", "🚙", "🦽", "🦼",
        "🛴", "🛵", "🚠", "🚂", "🛥",
        "🚚", "🚛", "🚜", "🚑", "🚒"
    ]
    
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    // 변경될 때마다 항상 objectWillChange.send()를 호출한다.
    
    var cards: [Card] {
        return model.cards
    }
    
    private static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame<String>(
            numberOfPairOfCards: 4,
            createCardContent: { index in
                return Self.emojis[index]
            }
        )
    }
    
    // MARK: - Intent(s)
    func choose(_ card: Card) {
//        objectWillChange.send() // 뷰를 다시 그리게 된다. (reloadData같은 느낌...? 컴바인으로 구현되어 있는듯)
        model.choose(card)
    }
}

// 흠... 이렇게 하는게 맞나...
