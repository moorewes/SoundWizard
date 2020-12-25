//
//  EQDLevel.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/17/20.
//

import Foundation

struct EQDLevel: Level, Identifiable {
    var id: String
    let game: Game
    var number: Int
    let difficulty: LevelDifficulty
    var audioMetadata: [AudioMetadata]
    var scoreData: ScoreData
        
    var bandFocus: BandFocus
    var filterGain: Gain
    var filterQ: Float
    
    lazy var octaveErrorRange: Octave = {
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
    
    var filterBoosts: Bool {
        filterGain.percentage > 0
    }
}
