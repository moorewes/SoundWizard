//
//  EQDetectiveTurn.swift
//  SoundWizard
//
//  Created by Wes Moore on 10/28/20.
//

import Foundation

struct EQDetectiveTurn {
    
    var number: Int
    var octaveErrorRange: Float
    var solution: Frequency
    
    private var startTime = Date()
    private(set) var completionTime: TimeInterval?
    private(set) var guess: Frequency?
    private(set) var score: TurnScore?
    private(set) var octaveError: Float?
    
    var isComplete: Bool { guess != nil }
    
    init(number: Int, level: EQDetectiveLevel) {
        self.number = number
        self.octaveErrorRange = level.octaveErrorRange
        
        solution = AudioCalculator.randomFreq(in: level.freqGuessRange)
    }

    mutating func finish(guess: Frequency) {
        self.guess = guess
        octaveError = abs(AudioCalculator.octave(fromFreq: guess, baseOctaveFreq: solution))
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
        }
        
        return TurnScore(value: value, successLevel: successLevel)
    }
    
}
