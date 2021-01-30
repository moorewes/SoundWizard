//
//  TurnScore.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/6/20.
//

import Foundation

struct Score {
    var value: Double
    var successLevel: ScoreSuccess
    
    func randomFeedbackString() -> String {
        return ScoreFeedback.randomString(for: successLevel)
    }
}
