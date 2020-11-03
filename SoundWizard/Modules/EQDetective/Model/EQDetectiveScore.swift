//
//  EQDetectiveScore.swift
//  SoundWizard
//
//  Created by Wes Moore on 10/29/20.
//

import Foundation

struct EQDetectiveRoundScore {
    var value: Float = 0.0
}

struct EQDetectiveTurnScore {
    
    var value: Float
    var successLevel: ScoreSuccessLevel
    
    init(octaveError: Float, octaveErrorRange: Float) {
        let scoreRatio = (octaveErrorRange - octaveError) / octaveErrorRange
        successLevel = ScoreSuccessLevel(score: scoreRatio)
        if scoreRatio <= 0 {
            value = 0
        } else {
            let accuracyModifier = max(0, 80 * scoreRatio)
            value = 20 + accuracyModifier
        }
    }
    
    func randomFeedbackString() -> String {
        return ScoreFeedback.randomString(for: successLevel)
    }
}
