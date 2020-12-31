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
        var solution: [EQBellFilterData]
        let guessError: EQMatchLevel.GuessError
        var score: Score? { result?.score }
        var result: Result?
        
        mutating func endTurn(guess: [EQBellFilterData]) {
            result = Result(turn: self, guessData: guess)
        }
    }
}

extension EQMatchGame.Turn {
    struct Result {
        let bands: [BandData]
        let score: Score
        
        // TODO: Refactor
        init(turn: EQMatchGame.Turn, guessData: [EQBellFilterData]) {
            bands = guessData.enumerated().map { (index, guess) in
                let solution = turn.solution[index]
                var scores: (frequency: Score?, gain: Score?)
                if let maxOctaveError = turn.guessError.octaves {
                    scores.frequency = ScoreEngine.score(guess: guess.frequency,
                                                         solution: solution.frequency,
                                                         maxOctaveError: maxOctaveError)
                }
                if let maxGainError = turn.guessError.gain {
                    scores.gain = ScoreEngine.score(guess: guess.gain, solution: solution.gain, maxGainError: maxGainError)
                }
                return BandData(solution: solution,
                                guess: guess,
                                scores: scores)
            }
            score = EQMatchGame.Scoring.score(for: bands)
        }
    }
}

extension EQMatchGame.Turn.Result {
    struct BandData {
        let solution: EQBellFilterData
        let guess: EQBellFilterData
        let scores: (frequency: Score?, gain: Score?)
    }
}

extension EQMatchGame {
    enum Scoring {
        static func score(for bands: [Turn.Result.BandData]) -> Score {
            let scores = bands
                .compactMap { [$0.scores.frequency, $0.scores.gain] }
                .flatMap { $0 }
                .compactMap { $0 }
            
            return Score(value: scores.meanValue, successLevel: scores.meanSuccess)
        }
        
    }
}
