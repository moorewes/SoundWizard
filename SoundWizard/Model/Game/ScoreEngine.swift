//
//  ScoreEngine.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/27/20.
//

import Foundation

enum ScoreEngine {
    
    static func score(guess: Frequency, solution: Frequency, maxOctaveError: Double) -> Score {
        let error = abs(guess.octaves(to: solution))
        let scoreRatio = 1 - error / maxOctaveError
        let successLevel = ScoreSuccess(score: scoreRatio)
        
        var value = 0.0
        if scoreRatio > 0 {
            let accuracyModifier = max(0, 80 * scoreRatio)
            value = 20 + accuracyModifier
        }
        
        return Score(value: value, successLevel: successLevel)
    }
    
    static func score(guess: Gain, solution: Gain, maxGainError: Gain) -> Score {
        let error = abs(guess.dB - solution.dB)
        let scoreRatio = 1 - error / maxGainError.dB
        return score(ratio: scoreRatio)
        
    }
    
    static func score(ratio: Double) -> Score {
        let successLevel = ScoreSuccess(score: ratio)
        
        var value = 0.0
        if ratio > 0 {
            let accuracyModifier = max(0, 80 * ratio)
            value = 20 + accuracyModifier
        }
        
        return Score(value: value, successLevel: successLevel)
    }
    
}
