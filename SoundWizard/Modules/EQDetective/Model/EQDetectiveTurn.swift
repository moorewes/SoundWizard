//
//  EQDetectiveTurn.swift
//  SoundWizard
//
//  Created by Wes Moore on 10/28/20.
//

import Foundation

struct EQDetectiveTurn: Turn {
    
    let number: Int
    let octaveErrorRange: Octave
    let solution: Frequency
    let scoreMultiplier: Float
    
    private var startTime = Date()
    private(set) var completionTime: TimeInterval?
    private(set) var guess: Frequency?
    private(set) var score: TurnScore?
    private(set) var octaveError: Float?
    
    var isComplete: Bool { guess != nil }
    
    init(number: Int, octaveErrorRange: Octave, solution: Frequency, scoreMultiplier: Float) {
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
        let scoreRatio = (octaveErrorRange - octaveError) / octaveErrorRange
        let successLevel = ScoreSuccessLevel(score: scoreRatio)
        
        var value: Float = 0
        if scoreRatio > 0 {
            let accuracyModifier = max(0, 80 * scoreRatio)
            value = 20 + accuracyModifier
            value *= scoreMultiplier
        }
        
        return TurnScore(value: value, successLevel: successLevel)
    }
    
}
