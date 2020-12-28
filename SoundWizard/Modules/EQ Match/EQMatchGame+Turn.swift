//
//  EQMatchGame+Turn.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/27/20.
//

import Foundation

extension EQMatchGame {
    struct Turn: GameTurn {
        let number: Int
        let maxOctaveError: Float?
        let guessError = EQMatchLevel.GuessError
        var score: Score?
        var result: Result?
        
        var frequencyVaries: Bool {
            maxOctaveError != nil
        }
        
        mutating func endTurn(guess: [EQBellFilterData]) {
            result = Result(turn: self, guessData: guess)
        }
        
//        private func frequencyResult(guess: Frequency, solution: Frequency) -> (octaveError: Float, success: ScoreSuccess) {
//            let error = guess.octaves(to: solution)
//            let success = ScoreEngine.score(frequencyOctaveError: Double(error), against: Double(maxOctaveError!))
//            
//        }
    }
}

extension EQMatchGame.Turn {
    struct Result {
        let bands: [BandData]
        
        init(turn: EQMatchGame.Turn, guessData: [EQBellFilterData]) {
            bands = guessData.enumerated().map { (index, guess) in
                let solution = turn.solution[index]
                let freqSuccess = ScoreSuccess.perfect
                let gainSuccess = ScoreSuccess.perfect
                return BandData(solution: solution,
                                guess: guess,
                                successLevel: (freqSuccess, gainSuccess))
            }
        }

        // TODO: Remove (canvas testing only)
        init() {
            var bands = [BandData]()
            for _ in 0...1 {
                bands.append(BandData(solution: EQBellFilterData(frequency: 100, gain: Gain(dB: 5), q: 4), guess: EQBellFilterData(frequency: 1000, gain: Gain(dB: -5), q: 4), successLevel: (frequency: .perfect, gain: .fair)))
            }
            self.bands = bands
        }
    }
}

extension EQMatchGame.Turn.Result {
    struct BandData {
        let solution: EQBellFilterData
        let guess: EQBellFilterData
        let successLevel: (frequency: ScoreSuccess, gain: ScoreSuccess)
    }
}
