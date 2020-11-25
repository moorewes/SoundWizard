//
//  TurnScore.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/24/20.
//

import Foundation

struct TurnScore {
    
    var value: Float
    var successLevel: ScoreSuccessLevel
    
    func randomFeedbackString() -> String {
        return ScoreFeedback.randomString(for: successLevel)
    }
    
}
