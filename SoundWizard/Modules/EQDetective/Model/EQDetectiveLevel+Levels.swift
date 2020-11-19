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
                        starScores: [300, 400, 1600],
                        filterGainDB: 6.0,
                        filterQ: 2.0,
                        octaveErrorRange: 2.0),
        
        EQDetectiveLevel(levelNumber: 2,
                         audioSource: .pinkNoise,
                         starScores: [300, 400, 600],
                        filterGainDB: 4.0,
                        filterQ: 4.0,
                        octaveErrorRange: 2.0),
        
        EQDetectiveLevel(levelNumber: 3,
                         audioSource: .acousticDrums,
                         starScores: [300, 400, 600],
                        filterGainDB: -10.0,
                        filterQ: 4.0,
                        octaveErrorRange: 2.0),
        
        EQDetectiveLevel(levelNumber: 4,
                         audioSource: .pinkNoise,
                         starScores: [300, 400, 600],
                         filterGainDB: -10.0,
                         filterQ: 4.0,
                         octaveErrorRange: 2.0),
        
    ]
    
}
