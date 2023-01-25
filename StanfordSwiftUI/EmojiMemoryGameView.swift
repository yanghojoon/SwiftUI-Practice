import SwiftUI

// MARK: - Struct와 Class의 차이점
// - 값타입과 참조 타입
// 값타입 : 변수를 할당하게 되면 값 타입이 복사된다. Copy on write를 사용해 변경할 때 복사를 하게 된다. / 함수형 프로그래밍 / 상속 X / 가변성은 명시적으로 표시되어 있어야 한다.
// 참조타입 : 포인터를 전달해서 힙 메모리에 있는 값을 가리킨다. ARC를 사용 / 객체지향 프로그래밍 / 단일 상속 / 항상 가변적이다.
// 모든 뷰에 공유가 되기 위해 ViewModel은 class로 선언된다.

// MARK: View
/*
 뷰는 보통 변경할 변수를 가질 만큼 충분히 긴 라이프사이클을 가지고 있지 않다. 따라서 View는 기본적으로 read only이다.
 다만 상태를 가져야 한다면 @state를 사용하면 된다. 다만 @state를 붙였다면 private 해야 하며 해당 뷰에서만 사용해야 한다.
 변경에 따라 View가 다시 그려진다는 점에서 @ObservedObject와 유사하다.
 @state를 사용하게 되면 힙 공간에 이를 저장할 공간을 생성하게 된다. View가 유지되는 한 저장 공간 또한 유지된다. 만약 뷰가 사라지게 되면 이때 메모리에서
 해제시켜주게 된다.
 하지만 최대한 모델을 활용하는 것이 좋으며 @state는 최대한 사용하지 않는 것이 좋다. 
 */

/*
 레이아웃은 어떻게 정해질까?
 1. ContainerView는 View에게 내부 공간을 제공한다. (이는 종류별로 다르게 할당한다)
 2. view는 필요한 만큼 사이즈를 정한다.
 3. ContainerView는 View를 위치시킨다.
 4. 이에 따라 ContainerView의 사이즈를 정하게 된다.
 
 HStack / VStack
 - 가장 유연하지 않은 View먼저 공간을 제공한다 (여기서 유연하지 않은 뷰는 Image나 Text 등이다. RoundedRectangle은 유연한 뷰이다.
 - 내부에 유연한 View가 들어가면 스택 자체도 유연하게 크기를 조절하게 된다.
 - 내부 뷰의 경우 .layoutPriority를 부여할 수 있다. (Hugging Compression과 유사) 지정하지 않으면 0이 기본이다.
 - alignment도 정할 수 있다. VStack(alignment: .leading) { }
 
 LazyHStack / LazyVStack
 - View가 화면에 보이지 않는 경우 이를 빌드하지 않는다.
 - 내부에 유연한 뷰가 있더라도 이를 전부 그리지 않으며 최대한 작게 만들게 된다.
 
 List / Form / OutlineGroup
 - 똑똑한 VStack의 한 종류이다.
 
 ZStack
 - 자식 뷰의 크기에 맞게 그려진다.
 - .background 와 매우 유사하다.
 - .overlay의 경우 그 위에 올리게 된다.
 
 Modifier (ex. .padding)
 - 스스로 뷰를 반환하는 함수이다.
 
 GeometryReader
 
 @ViewBuilder
 뷰의 리스트
 */

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    // 명령형의 경우 UI와 상호작용을 할 때 이를 수정하기 위해 더 많은 함수를 호출하게 된다.
    // 제대로 되어 있는지 확인하려면 UI 상태에 영향을 줄 수 있는 모든 함수를 호출해서 가능한 모든 경로를 예상해야 한다.
    
    // SwiftUI는 선언형이자 반응형으로 모델의 변경사항에 따라 View를 새롭게 그려주게 된다.
    
    var body: some View { // 항상 State를 반영하도록 반환해야 한다. View 자체는 수정이 안되며 이를 수정하기 위해선 다시 빌드를 해야 한다.
        ScrollView(showsIndicators: false) {
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 65)) // 화면 크기에 맞춰 최소 65 가로를 갖는 item이 들어가게 된다.
                ]
            ) {
                ForEach(game.cards, id: \.id) { card in
                    CardView(card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .onTapGesture {
                            game.choose(card)
                        }
                }
            }
        }
        .foregroundColor(.red)
        .padding(.horizontal)
    }
}

struct CardView: View {
    private enum DrawingConstant {
        static let cornerRadius: CGFloat = 25
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.8
    }
    
    private let card: EmojiMemoryGame.Card
    
    init(_ card: EmojiMemoryGame.Card) {
        self.card = card
    }
    
    var body: some View {
        GeometryReader(content: { geometry in // 제공한 모든 공간을 사용
            ZStack(alignment: .center) {
                let roundedRectangle = RoundedRectangle(cornerRadius: DrawingConstant.cornerRadius)
                
                if card.isFaceUp {
                    roundedRectangle
                        .fill()
                        .foregroundColor(.white)
                    
                    roundedRectangle
                        .strokeBorder(lineWidth: DrawingConstant.lineWidth)
                    
                    Text("\(card.content)")
                        .font(font(in: geometry.size))
                        .foregroundColor(.brown)
                } else if card.isMatched {
                    roundedRectangle.opacity(0)
                } else {
                    roundedRectangle
                        .fill()
                }
            }
        })
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstant.fontScale)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        
        EmojiMemoryGameView(game: game)
            .preferredColorScheme(.dark)
        EmojiMemoryGameView(game: game)
            .preferredColorScheme(.light)
    }
}
