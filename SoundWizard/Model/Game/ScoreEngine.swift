//
//  ScoreEngine.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/27/20.
//

import Foundation

enum ScoreEngine {
    
    static func score(frequencyOctaveError error: Double, against maxError: Double) -> Score {
        let scoreRatio = (maxError - error) / maxError
        let successLevel = ScoreSuccess(score: scoreRatio)
        
        var value: Double = 0
        if scoreRatio > 0 {
            let accuracyModifier = max(0, 80 * scoreRatio)
            value = 20 + accuracyModifier
        }
        
        return Score(value: value, successLevel: successLevel)
    }
    
}
