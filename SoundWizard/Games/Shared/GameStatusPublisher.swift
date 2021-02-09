//
//  GameStatusPublisher.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/6/20.
//

import Foundation

protocol GameStatusProviding {
    var score: Int { get }
    var scoreMultiplierValue: Double? { get }
    var maxLives: Int { get }
    var remainingLives: Int { get }
}

extension GameStatusProviding where Self: ScoreMultipliable {
    var scoreMultiplierValue: Double? {
        scoreMultiplier.value
    }
}

extension GameStatusProviding where Self: LivesBased {
    var maxLives: Int {
        return lives.max
    }
}
