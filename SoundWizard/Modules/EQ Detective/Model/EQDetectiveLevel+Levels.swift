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
        let context = CoreDataManager.shared.container.viewContext
        for source in AudioSource.allSources(context: context) {
            for focus in BandFocus.allCases {
                for difficulty in LevelDifficulty.allCases {
                    let scores = starScores(for: difficulty)
                    let q = qValue(for: difficulty)
                    for gain in gainValues(for: difficulty) {
                        result.append(EQDetectiveLevel(levelNumber: result.count,
                                                       audioSourceID: source.id,
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
    
}
