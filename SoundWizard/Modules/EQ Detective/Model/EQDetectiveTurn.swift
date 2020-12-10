//
//  EQDetectiveTurn.swift
//  SoundWizard
//
//  Created by Wes Moore on 10/28/20.
//

import Foundation

struct EQDetectiveTurn: GameTurn {
    
    let number: Int
    let octaveErrorRange: Octave
    let solution: Frequency
    let scoreMultiplier: Double
    
    private var startTime = Date()
    private(set) var completionTime: TimeInterval?
    private(set) var guess: Frequency?
    private(set) var score: TurnScore?
    private(set) var octaveError: Float?
    
    var isComplete: Bool { guess != nil }
    
    init(number: Int, octaveErrorRange: Octave, solution: Frequency, scoreMultiplier: Double) {
        self.number = number
        self.octaveErrorRange = octaveErrorRange
        self.solution = solution
        self.scoreMultiplier = scoreMultiplier
    }

    mutating func finish(guess: Frequency) {
        self.guess = guess
        octaveError = abs(guess.octaves(to: solution))
        completionTime = Date().timeIntervalSince(startTime)
        score = score(for: octaveError!)
    }
    
    mutating private func score(for octaveError: Float) -> TurnScore {
        let scoreRatio = Double((octaveErrorRange - octaveError) / octaveErrorRange)
        let successLevel = ScoreSuccess(score: scoreRatio)
        
        var value: Double = 0
        if scoreRatio > 0 {
            let accuracyModifier = max(0, 80 * scoreRatio)
            value = 20 + accuracyModifier
            value *= scoreMultiplier
        }
        
        return TurnScore(value: value, successLevel: successLevel)
    }
    
}
