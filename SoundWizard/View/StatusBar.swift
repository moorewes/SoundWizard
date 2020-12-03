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
        HStack() {
            
            VStack {
                Text("SCORE")
                    .font(.monoBold(16))
                    .foregroundColor(.init(white: 1, opacity: 0.5))
                MovingCounter(number: game.score)
                    .animation(.linear(duration: 0.5))
            }
            
            
            Text(" x\(Int(game.scoreMultiplier))")
                .font(.monoBold(20))
                .foregroundColor(.teal)
            
            Spacer()
            
            
            VStack {
                Text("LIVES")
                    .font(.monoBold(16))
                    .foregroundColor(.init(white: 1, opacity: 0.5))
                    .offset(CGSize(width: 0, height: -9))
                
                HStack() {
                    ForEach(0..<game.maxLives) { i in
                        let visible = game.maxLives - i - 1 < game.lives
                        Image(systemName: "heart.fill")
                            .foregroundColor(.teal)
                            .opacity(visible ? 1 : 0)
                            .scaleEffect(visible ? 1 : 0)
                            .animation(visible ?
                                       .easeIn(duration: 0.5) :
                                       .easeIn(duration: 1.5))
                    }
                }
                
            }
            //.frame(width: nil, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            //.padding()
        }
        
    }
    
}

struct StatusBar_Previews: PreviewProvider {
    static var previews: some View {
        StatusBar(game: EQDetectiveGame(level: EQDetectiveLevel.level(1)!, viewState: .constant(.inGame)))
            .background(Color.darkBackground)
    }
}
