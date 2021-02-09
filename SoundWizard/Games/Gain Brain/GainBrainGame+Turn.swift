//
//  GainBrainGame+Turn.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/8/21.
//

import Foundation

extension GainBrainGame {
    struct Turn: GameTurn {
        var number: Int
        let solution: Solution
        var choices: [Choice]
        var score: Score?
    }
}

extension GainBrainGame.Turn {
    typealias Choice = Solution
    struct Solution {
        let gain: Double
        
        static let possibleGainValues: [Double] = [-24, -22, -20, -18, -16, -14, -12, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6]
    }
}
