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
            
            GuessLabels(data: game.guessFilterData)
            
            InteractiveEQPlot(filters: $game.guessFilterData, canAdjustGain: true, canAdjustFrequency: game.level.changesFrequency)
                .padding(.vertical, 30)
            
            ActionButton(game: game)
                .padding(.vertical, 30)
            
        }
    }
}

extension EQMatchGameplayView {
    struct GuessLabels: View {
        let data: [EQBellFilterData]
        
        var body: some View {
            HStack {
                Spacer()
                ForEach(data, id: \.self) { data in
                    VStack {
                        Text(data.gain.dB.uiString + "dB")
                            .font(.mono(.body))
                            .foregroundColor(.white)
                        Text(data.frequency.decimalStringWithUnit)
                            .font(.mono(.body))
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
            }
        }
    }
}

extension EQMatchGameplayView {
    
    struct ActionButton: View {
        let game: EQMatchGame
        
        var body: some View {
            Button(game.actionButtonTitle) {
                game.action()
            }
            .buttonStyle(ActionButtonStyle())
        }
    }
    
}

struct EQMatchGameplayView_Previews: PreviewProvider {
    static let level: EQMatchLevel = TestData.eqMatchLevel
    
    static var previews: some View {
        level.buildGame(gameHandler: TestData.GameHandler(state: .playing))
    }
}
