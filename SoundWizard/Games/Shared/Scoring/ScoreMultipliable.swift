//
//  ScoreMultipliable.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/6/20.
//

import Foundation

struct ScoreMultiplier {
    let max: Double = 4
    let turnSuccessNeededForStreak = ScoreSuccess.fair
    
    var streakTarget = 4
    
    var value: Double = 1
    var streak = 0 {
        didSet {
            guard streak > 0 else { return }
            value += streak % streakTarget == 0 ? 1 : 0
        }
    }
    
    mutating func update(for success: ScoreSuccess) {
        streak += success >= turnSuccessNeededForStreak ? 1 : -streak
    }
}
