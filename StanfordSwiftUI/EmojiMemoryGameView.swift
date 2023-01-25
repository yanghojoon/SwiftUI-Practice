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

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
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
                ForEach(viewModel.cards, id: \.id) { card in
                    CardView(card: card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                }
            }
        }
        .foregroundColor(.red)
        .padding(.horizontal)
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    var body: some View {
        ZStack(alignment: .center) {
            let roundedRectangle = RoundedRectangle(cornerRadius: 25)
            
            if card.isFaceUp {
                roundedRectangle
                    .fill()
                    .foregroundColor(.white)
                
                roundedRectangle
                    .strokeBorder(lineWidth: 3)
                
                Text("\(card.content)")
                    .font(.largeTitle)
                    .foregroundColor(.brown)
            } else if card.isMatched {
                roundedRectangle.opacity(0)
            } else {
                roundedRectangle
                    .fill()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        
        EmojiMemoryGameView(viewModel: game)
            .preferredColorScheme(.dark)
        EmojiMemoryGameView(viewModel: game)
            .preferredColorScheme(.light)
    }
}
