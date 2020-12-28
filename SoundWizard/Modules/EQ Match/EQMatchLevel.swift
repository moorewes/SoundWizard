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
    
    lazy var guessError = GuessError(difficulty: difficulty)
    var variesFrequency: Bool { staticFrequencies == nil }
}

extension EQMatchLevel {
    struct GuessError {
        var gain: Float
        var octaves: Float
        
        init(difficulty: LevelDifficulty) {
            switch difficulty {
            case .easy:
                octaves = bandFocus.octaveSpan / 4
                gain = 5
            case .moderate:
                octaves = bandFocus.octaveSpan / 6
                gain = 4
            case .hard:
                octaves = bandFocus.octaveSpan / 8
                gain = 3
            case .custom:
                octaves = bandFocus.octaveSpan / 4
                gain = 5
            }
        }
    }
}
