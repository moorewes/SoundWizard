//
//  GainBrainGame+Turn.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/8/21.
//

import Foundation

extension GainBrainGame {
    struct Choice: MultipleChoiceGameChoice {
        var gain: Double
        var isCorrect: Bool = false
        
        var title: String { "\(Int(gain)) dB" }
        var id: String { title }
    }
}

extension GainBrainGame.Choice  {
    static let possibleGainValues: [Double] = [
        -24, -22, -20, -18, -16, -14, -12, -10, -9, -8,
        -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6
    ]
    
    static var possibleChoices: [Self] {
        possibleGainValues.map { GainBrainGame.Choice(gain: $0) }
    }
}
