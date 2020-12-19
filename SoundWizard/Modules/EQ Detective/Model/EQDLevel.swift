//
//  EQDLevel.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/17/20.
//

import Foundation

struct EQDLevel: Level, Identifiable {
    
    var id: String
    var game: Game
    var number: Int
    var difficulty: LevelDifficulty
    var audioMetadata: [AudioMetadata]
    var scoreData: ScoreData
        
    let bandFocus: BandFocus
    let filterGain: Float
    let filterQ: Float
    
    lazy var octaveErrorRange: Octave = {
        switch difficulty {
        case .easy:
            return bandFocus.octaveSpan / 4
        case .moderate:
            return bandFocus.octaveSpan / 6
        case .hard:
            return bandFocus.octaveSpan / 8
        }
    }()
    
    var filterBoosts: Bool {
        filterGain > 0
    }
}
