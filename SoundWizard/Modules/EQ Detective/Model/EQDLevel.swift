//
//  EQDLevel.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/17/20.
//

import Foundation

struct EQDLevel: Level, Identifiable {
    
    var id: String
    let isStock: Bool
    let game: Game
    let number: Int
    let difficulty: LevelDifficulty
    let audioMetadata: [AudioMetadata]
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

// MARK: ID Factory

extension EQDLevel {
    
    static func makeID(isStock: Bool, number: Int, audioSources: [AudioMetadata]) -> String {
        let typeString = isStock ? "stock" : "custom"
        let sourceString = audioSources.count == 1 ?
                            audioSources.first!.name :
                            "multipleAudioSources"
        
        return "\(Game.eqDetective.id).\(typeString).\(number).\(sourceString)"
    }
    
}
