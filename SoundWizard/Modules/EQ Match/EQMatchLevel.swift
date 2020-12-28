//
//  EQMatchLevel.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/6/20.
//

import Foundation

struct EQMatchLevel: Level {
    var id: String
    var game: Game
    var number: Int
    var audioMetadata: [AudioMetadata]
    var difficulty: LevelDifficulty
    var scoreData: ScoreData
    
    var bandFocus: BandFocus
    let filterCount: Int
    let staticFrequencies: [Frequency]?
    var variesFrequency: Bool { staticFrequencies == nil }
    
    lazy var maxOctaveError: Float = {
        switch difficulty {
        case .easy:
            return bandFocus.octaveSpan / 4
        case .moderate:
            return bandFocus.octaveSpan / 6
        case .hard:
            return bandFocus.octaveSpan / 8
        case .custom:
            return bandFocus.octaveSpan / 4
        }
    }()
}
