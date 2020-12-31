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
    @State var gain: Double = 0
    @State var mode: String = "bypassed"
    
    var body: some View {
        VStack() {
            StatusBar(game: game)
                .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                .opacity(game.practicing ? 0 : 1)
            
            Rectangle()
                .opacity(0)
                .frame(width: 200, height: 50, alignment: .center)
            
            FilterInfo(guesses: game.solutionFilterData, results: game.turnResult)
                .padding(.top, 40)
                .opacity(game.showingResults ? 0 : 0)
            
            FilterInfo(guesses: game.guessFilterData, results: game.turnResult)
                .padding(.top, 40)

            ZStack {
                InteractiveEQPlot(filters: $game.guessFilterData,
                                  frequencyRange: game.frequencyRange,
                                  gainRange: game.gainRange)
                    .padding(.bottom, 20)
                if game.showingResults {
                    BellPath(filters: CGFilters(filters: game.solutionFilterData,
                                                frequencyRange: game.frequencyRange,
                                                gainRange: game.gainRange),
                             filled: false,
                             strokeColor: game.solutionLineColor)
                        .padding(.bottom, 20)
                }
                
            }
            
            FilterPicker(mode: $game.filterMode)
                .padding(.horizontal, 25)
                .padding(.vertical, 20)
            
            Button(game.actionButtonTitle) {
                game.action()
            }
                .buttonStyle(ActionButtonStyle())
                .padding(20)
            
            Spacer(minLength: 40)
        }
        .onDisappear() {
            game.stopAudio()
        }
    }
}

extension EQMatchGameplayView {
    struct FilterPicker: View {
        @Binding var mode: EQMatchGame.FilterMode
        var body: some View {
            Picker("", selection: $mode) {
                ForEach(EQMatchGame.FilterMode.allCases) { mode in
                    Text(title(for: mode)).tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        
        private func title(for mode: EQMatchGame.FilterMode) -> String {
            switch mode {
            case .solution:
                return "Solution"
            case .guess:
                return "Guess"
            }
        }
    }
}

extension EQMatchGameplayView {
    struct FilterInfo: View {
        let guesses: [EQBellFilterData]
        let results: EQMatchGame.Turn.Result?// = EQMatchGame.Turn.Result()
        
        var body: some View {
            HStack {
                ForEach(guesses.indices, id: \.self) { index in
                    Spacer()
                    VStack {
                        ValuesRow(data: gainData(for: index))
                        ValuesRow(data: freqData(for: index))
                    }
                    Spacer()
                    
                }
            }
        }
        
        private func freqData(for index: Int) -> RowData {
            let frequency = guesses[index].frequency
            let guess = frequency.decimalString
            let unit = frequency.unitString
            guard let result = results?.bands[index],
                  let score = result.scores.frequency else {
                return RowData(guess: guess, unit: unit)
            }
            
            let solution = result.solution.frequency.decimalString
            let color = Color.successLevelColor(score.successLevel)
            return RowData(guess: guess, unit: unit, solution: solution, valueColor: color)
        }
        
        private func gainData(for index: Int) -> RowData {
            let gain = guesses[index].gain
            let guess = gain.intValueString
            let unit = gain.unitString
            guard let result = results?.bands[index],
                  let score = result.scores.gain else {
                return RowData(guess: guess, unit: unit)
            }
            
            let solution = result.solution.gain.intValueString
            let color = Color.successLevelColor(score.successLevel)
            return RowData(guess: guess, unit: unit, solution: solution, valueColor: color)
        }
    }
}

struct EQMatchGameplayView_Previews: PreviewProvider {
    static let level: EQMatchLevel = TestData.eqMatchLevel
    
    static var previews: some View {
        level.buildGame(gameHandler: TestData.GameHandler(state: .playing))
    }
}

fileprivate extension EQMatchGame.Turn.Result {
    init() {
        var bands = [BandData]()
        for _ in 0...1 {
            bands.append(
                BandData(solution: EQBellFilterData(frequency: 100,
                                                    gain: Gain(dB: 5),
                                                    q: 4),
                         guess: EQBellFilterData(frequency: 1000,
                                                 gain: Gain(dB: -5),
                                                 q: 4),
                         scores: (Score(value: 40, successLevel: .fair),
                                   Score(value: 80, successLevel: .great))
                )
            )
        }
        self.bands = bands
        score = Score(value: 100, successLevel: .fair)
    }
}


