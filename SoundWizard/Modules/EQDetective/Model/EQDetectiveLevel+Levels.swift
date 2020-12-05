//
//  EQDetectiveLevel+Levels.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/4/20.
//

import Foundation

extension EQDetectiveLevel {
    
    static func starScores(for difficulty: LevelDifficulty) -> [Int] {
        switch difficulty {
        case .easy: return [300, 500, 700]
        case .moderate: return [500, 800, 1100]
        case .hard: return [600, 900, 1200]
        }
    }
    
    static func gainValues(for difficulty: LevelDifficulty) -> [Float] {
        switch difficulty {
        case .easy: return [8]
        case .moderate: return [6, -8]
        case .hard: return [4, -6]
        }
    }
    
    static func qValue(for difficulty: LevelDifficulty) -> Float {
        switch difficulty {
        case .easy: return 8
        case .moderate: return 6
        case .hard: return 6
        }
    }
    
    // MARK: - Level Constuctors
    
    static var levels: [EQDetectiveLevel] {
        var result = [EQDetectiveLevel]()
        for source in AudioSource.all {
            for focus in BandFocus.allCases {
                for difficulty in LevelDifficulty.allCases {
                    let scores = starScores(for: difficulty)
                    let q = qValue(for: difficulty)
                    for gain in gainValues(for: difficulty) {
                        result.append(EQDetectiveLevel(levelNumber: result.count,
                                                       audioSource: source,
                                                       starScores: scores,
                                                       filterGainDB: gain,
                                                       filterQ: q,
                                                       difficulty: difficulty,
                                                       bandFocus: focus))
                    }
                }
            }
        }
        return result
    }
    
    static var testLevels: [EQDetectiveLevel] = [
        
        EQDetectiveLevel(levelNumber: 1,
                        audioSource: .acousticDrums,
                        starScores: [500, 800, 1200],
                        filterGainDB: 8.0,
                        filterQ: 4.0,
                        difficulty: .easy,
                        bandFocus: .all),
        
        EQDetectiveLevel(levelNumber: 2,
                         audioSource: .pinkNoise,
                         starScores: [300, 400, 600],
                        filterGainDB: -8.0,
                        filterQ: 8.0,
                        difficulty: .easy,
                        bandFocus: .low),
        
        EQDetectiveLevel(levelNumber: 3,
                         audioSource: .aero,
                         starScores: [300, 400, 600],
                        filterGainDB: 8.0,
                        filterQ: 8.0,
                        difficulty: .easy,
                        bandFocus: .lowMid),
        
        EQDetectiveLevel(levelNumber: 4,
                         audioSource: .asia,
                         starScores: [300, 400, 600],
                         filterGainDB: 6.0,
                         filterQ: 4.0,
                         difficulty: .easy,
                         bandFocus: .mid),
        
        EQDetectiveLevel(levelNumber: 5,
                         audioSource: .brick,
                         starScores: [300, 400, 600],
                         filterGainDB: 8.0,
                         filterQ: 10.0,
                         difficulty: .easy,
                         bandFocus: .upperMid),
        
        EQDetectiveLevel(levelNumber: 6,
                         audioSource: .cry,
                         starScores: [300, 400, 600],
                         filterGainDB: 8.0,
                         filterQ: 8.0,
                         difficulty: .easy,
                         bandFocus: .lowMid),
        
        EQDetectiveLevel(levelNumber: 7,
                         audioSource: .dawn,
                         starScores: [300, 400, 600],
                         filterGainDB: 8.0,
                         filterQ: 8.0,
                         difficulty: .easy,
                         bandFocus: .all),
        EQDetectiveLevel(levelNumber: 8,
                        audioSource: .acousticDrums,
                        starScores: [500, 800, 1200],
                        filterGainDB: 8.0,
                        filterQ: 8.0,
                        difficulty: .moderate,
                        bandFocus: .mid),
        EQDetectiveLevel(levelNumber: 9,
                        audioSource: .acousticDrums,
                        starScores: [500, 800, 1200],
                        filterGainDB: 8.0,
                        filterQ: 8.0,
                        difficulty: .moderate,
                        bandFocus: .high),
        EQDetectiveLevel(levelNumber: 10,
                        audioSource: .pinkNoise,
                        starScores: [500, 800, 1200],
                        filterGainDB: 8.0,
                        filterQ: 8.0,
                        difficulty: .hard,
                        bandFocus: .lowMid),
        
        
    ]
    
}
