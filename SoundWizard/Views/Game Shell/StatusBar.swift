//
//  StatusBar.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/25/20.
//

import SwiftUI

struct StatusBar<GameStatus: GameStatusPublisher & ObservableObject>: View {
    @ObservedObject var game: GameStatus
    
    var body: some View {
        HStack() {
            VStack {
                Text("SCORE")
                    .font(.mono(.callout))
                    .foregroundColor(.init(white: 1, opacity: 0.5))
                Text("\(game.score)")
                    .modifier(MovingCounterModifier(number: game.score,
                                                    font: .mono(.title3)))
                    .animation(.linear(duration: 0.5))
            }
            
            Text(" x\(Int(game.scoreMultiplierValue))")
                .font(.mono(.headline))
                .foregroundColor(.teal)
            
            Spacer()
            
            VStack {
                Text("LIVES")
                    .font(.mono(.callout))
                    .foregroundColor(.init(white: 1, opacity: 0.5))
                    .offset(CGSize(width: 0, height: -9))
                
                HStack() {
                    ForEach(0..<game.maxLives) { i in
                        let visible = game.maxLives - i - 1 < game.remainingLives
                        Image(systemName: "heart.fill")
                            .foregroundColor(.teal)
                            .opacity(visible ? 1 : 0)
                            .scaleEffect(visible ? 1 : 0.01)
                            .animation(visible ?
                                       .easeIn(duration: 0.5) :
                                       .easeIn(duration: 1.5))
                    }
                }
            }
        }
    }
}
