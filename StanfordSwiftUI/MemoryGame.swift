import Foundation

struct MemoryGame<CardContent: Equatable> where CardContent: Equatable {
    // 구조체 내부에 구조체를 넣으면 이것의 이름은 MemoryGame.Card가 된다.
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        let content: CardContent
        
        let id: Int
    }
    
    private(set) var cards: [Card]
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
    }
    
    init(numberOfPairOfCards: Int, createCardContent: (Int) -> CardContent) {
        self.cards = [Card]()
        for index in  0 ..< numberOfPairOfCards {
            let content = createCardContent(index)
            
            cards.append(Card(content: content, id: index * 2))
            cards.append(Card(content: content, id: index * 2 + 1))
        }
    }
    
    mutating func choose(_ card: Card) { // View의 탭 제스쳐와 연결이 되어야 한다.
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
}

extension Array {
    var oneAndOnly: Element? {
        if count == 1 {
            return first
        } else {
            return nil
        }
    }
}
