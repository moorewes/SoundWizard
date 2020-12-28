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
            
            Rectangle()
                .opacity(0)
                .frame(width: 200, height: 150, alignment: .center)
            
            FilterInfo(guessData: game.guessFilterData, result: game.turnResult)
                .padding(.top, 40)
            
            InteractiveEQPlot(filters: $game.guessFilterData)
                .padding(.bottom, 60)
            
            ActionButton(game: game)
                .padding(.bottom, 60)
        }
    }
}

extension EQMatchGameplayView {
    struct FilterInfo: View {
        let guessData: [EQBellFilterData]
        let resultData: EQMatchGame.Turn.Result?// = EQMatchGame.Turn.Result()
        
        var body: some View {
            HStack {
                ForEach(guessData.indices, id: \.self) { index in
                    VStack {
                        ValuesRow(data: gainData(for: index))
                        ValuesRow(data: freqData(for: index))
                    }
                    Spacer()
                    
                }
            }
        }
        
        private func freqData(for index: Int) -> RowData {
            let frequency = guessData[index].frequency
            let guess = frequency.decimalString
            let unit = frequency.unitString
            guard let result = resultData?.bands[index] else {
                return RowData(guess: guess, unit: unit)
            }
            
            let solution = result.solution.frequency.decimalString
            let color = Color.successLevelColor(result.successLevel.frequency)
            return RowData(guess: guess, unit: unit, solution: solution, solutionColor: color)
        }
        
        private func gainData(for index: Int) -> RowData {
            let gain = guessData[index].gain
            let guess = gain.intValueString
            let unit = gain.unitString
            guard let result = resultData?.bands[index] else {
                return RowData(guess: guess, unit: unit)
            }
            
            let solution = result.solution.gain.intValueString
            let color = Color.successLevelColor(result.successLevel.frequency)
            return RowData(guess: guess, unit: unit, solution: solution, solutionColor: color)
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
