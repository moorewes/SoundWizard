//
//  GameStatusPublisher.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/6/20.
//

import Foundation

protocol GameStatusPublisher {
    var score: Int { get }
    var scoreMultiplierValue: Double { get }
    var maxLives: Int { get }
    var remainingLives: Int { get }
}

extension GameStatusPublisher where Self: ScoreMultipliable {
    var scoreMultiplierValue: Double {
        scoreMultiplier.value
    }
}

extension GameStatusPublisher where Self: LivesBased {
    var maxLives: Int {
        return lives.max
    }
}
