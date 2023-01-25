//
//  StanfordSwiftUIApp.swift
//  StanfordSwiftUI
//
//  Created by 양호준 on 2023/01/15.
//

import SwiftUI

@main
struct StanfordSwiftUIApp: App {
    private let game = EmojiMemoryGame() // 상수는 EmojiMemoryGame을 가리키고 있는 포인터
    // 클래스의 경우 포인터를 통해 변경이 가능하다.
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
