//
//  PlayButton.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/11/20.
//

import SwiftUI

struct PlayButton: View {
    
    @Binding var gameViewState: GameViewState
    
    var body: some View {
        Button(action: {
            gameViewState = .inGame
        }, label: {
            ZStack {
                Rectangle()
                    .foregroundColor(.teal)
                    .cornerRadius(10)
                    .frame(width: 200, height: 50, alignment: .center)
                Text("PLAY")
                    .font(.mono(.headline))
                    .foregroundColor(.darkBackground)
            }
            
        })
    }
}
