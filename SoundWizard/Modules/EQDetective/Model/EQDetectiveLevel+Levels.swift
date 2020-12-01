//
//  EQDetectiveLevel+Levels.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/4/20.
//

import Foundation

extension EQDetectiveLevel {
    
    // MARK: - Level Constuctors
    
    static var levels: [EQDetectiveLevel] = [
        
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
                        filterGainDB: 8.0,
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
                         bandFocus: .high),
        
        EQDetectiveLevel(levelNumber: 7,
                         audioSource: .dawn,
                         starScores: [300, 400, 600],
                         filterGainDB: 6.0,
                         filterQ: 4.0,
                         difficulty: .easy,
                         bandFocus: .all),
        EQDetectiveLevel(levelNumber: 8,
                        audioSource: .acousticDrums,
                        starScores: [500, 800, 1200],
                        filterGainDB: 8.0,
                        filterQ: 4.0,
                        difficulty: .moderate,
                        bandFocus: .mid),
        
        
    ]
    
}
