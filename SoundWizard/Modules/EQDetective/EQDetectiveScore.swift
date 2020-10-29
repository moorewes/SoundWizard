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
        self.value = max(0, 100 * scoreRatio)
        successLevel = ScoreSuccessLevel(score: scoreRatio)
    }
    
    func randomFeedbackString() -> String {
        return ScoreFeedback.randomString(for: successLevel)
    }
}
