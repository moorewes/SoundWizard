//
//  StatusBar.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/25/20.
//

import SwiftUI

struct StatusBar<Model: GameModel>: View {
    
    @ObservedObject var game: Model
    
    var body: some View {
        HStack(spacing: 50) {
            // Score
            
            VStack {
                Text("SCORE")
                    .font(.monoBold(16))
                    .foregroundColor(.init(white: 1, opacity: 0.5))
                MovingCounter(number: game.score)
                    .animation(.linear(duration: 0.5))
            }
            .frame(width: 80, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            VStack {
                Text("LIVES")
                    .font(.monoBold(16))
                    .foregroundColor(.init(white: 1, opacity: 0.5))
                
                HStack() {
                    ForEach(0..<game.startingLives) { i in
                        let visible = game.startingLives - i - 1 >= game.lives
                        Image(systemName: "heart.fill")
                            .foregroundColor(.teal)
                            .padding(2)
                            .opacity(visible ? 0 : 1)
                            .animation(.easeIn)
                    }
                }
                
            }
            .frame(width: nil, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding()
            
//            VStack {
//                Text("\(game.currentTurn?.number ?? 1) of 10")
//                    .font(.monoBold(16))
//                    .foregroundColor(.init(white: 1, opacity: 0.5))
//                ProgressView(value: game.completion)
//                    .accentColor(.teal)
//                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
//
//            }
//            .padding()
            
            
            
            Button(action: {
                game.toggleMute()
            }, label: {
                Image(systemName: muteButtonImageName)
                    .foregroundColor(.teal)
                    .scaleEffect(1.3)
                
            })
            .frame(width: 80, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        
    }
    
    var muteButtonImageName: String {
        game.muted ? "speaker" : "speaker.fill"
    }
    
}
