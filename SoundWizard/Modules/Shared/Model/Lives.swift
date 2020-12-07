//
//  Lives.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/6/20.
//

import Foundation

struct Lives {
    
    let starting = 2
    let max = 3
    var streakTarget = 3
    let successNeededForStreak = ScoreSuccess.great
    
    private(set) var remaining: Int {
        didSet {
            remaining = min(max, remaining)
        }
    }
    
    var streak = 0 {
        didSet {
            guard streak > 0 else { return }
            remaining += streak % streakTarget == 0 ? 1 : 0
        }
    }
    
    
    
    init() {
        remaining = starting
    }
    
    mutating func update(for success: ScoreSuccess) {
        if !success.succeeded {
            remaining -= 1
        }
        if success >= successNeededForStreak {
            streak += 1
        }
    }
    
}

protocol LivesBased {
    
    var lives: Lives { get set }
    var remainingLives: Int { get }
    
}

extension LivesBased {
    
    var remainingLives: Int {
        get {
            return lives.remaining
        }
    }

}
