//
//  EQMatchGameplayView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/6/20.
//

import SwiftUI

struct EQMatchGameplayView: View {
    
    @ObservedObject var game: EQMatchGame
    
    @State var frequency: Frequency = 1000
    @State var gain: Float = 0
    
    var body: some View {
        VStack() {
            StatusBar(game: game)
                .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                .opacity(game.practicing ? 0 : 1)
            
            HStack {
                ForEach(game.guessFilterData, id: \.self) { data in
                    Text(data.frequency.uiString)
                }
            }
            
            InteractiveEQPlot(filters: $game.guessFilterData, canAdjustGain: true, canAdjustFrequency: game.level.changesFrequency)
                .padding(.vertical, 30)
            
            Button("SUBMIT") {
                game.submitGuess()
            }
            .buttonStyle(ActionButtonStyle())
            .padding(.vertical, 30)
            
        }
    }
}

struct EQMatchGameplayView_Previews: PreviewProvider {
    static let level: EQMatchLevel = TestData.eqMatchLevel
    
    static var previews: some View {
        level.buildGame(gameHandler: TestData.GameHandler(state: .playing))
    }
}
