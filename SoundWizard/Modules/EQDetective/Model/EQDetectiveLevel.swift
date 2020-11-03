//
//  EQDetectiveLevel.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/2/20.
//

import Foundation

struct EQDetectiveLevel: Level {
    
    // MARK: - Internal Properties
    
    let numberOfTurns = 10
    
    let levelNumber: Int
    let audioSource: AudioSource
    let scores: (oneStar: Int, twoStar: Int, threeStar: Int)
    let filterGainDB: Float
    let filterQ: Float
    let octaveErrorRange: Float
    
    var userScore: Int = 0
    var starsEarned: Int = 0
    
    var nextlevel: EQDetectiveLevel? { return EQDetectiveLevel.levels[self.levelNumber + 1] }
    
    // MARK: - Internal Static Properties
    
    static var levelCount = levels.count
    
    // MARK: - Internal Static Methods
    
    static func level(_ levelNumber: Int) -> EQDetectiveLevel? {
        guard levels.count > levelNumber else { return nil }
        
        var level = levels[levelNumber]
        // TODO: Retrieve user score from data storage
        level.userScore = 0
        return level
    }
    
    // MARK: - Level Constuctors
    
    static var levels: [EQDetectiveLevel] = [
        
        EQDetectiveLevel(levelNumber: 1,
                            audioSource: .acousticDrums,
                            scores: (oneStar: 300, twoStar: 400, threeStar: 600),
                            filterGainDB: 6.0,
                            filterQ: 2.0,
                            octaveErrorRange: 2.0),
        EQDetectiveLevel(levelNumber: 2,
                         audioSource: .pinkNoise,
                            scores: (oneStar: 300, twoStar: 400, threeStar: 600),
                            filterGainDB: 4.0,
                            filterQ: 4.0,
                            octaveErrorRange: 2.0),
        EQDetectiveLevel(levelNumber: 3,
                         audioSource: .acousticDrums,
                            scores: (oneStar: 300, twoStar: 400, threeStar: 600),
                            filterGainDB: -10.0,
                            filterQ: 4.0,
                            octaveErrorRange: 2.0),
        EQDetectiveLevel(levelNumber: 4,
                         audioSource: .pinkNoise,
                            scores: (oneStar: 300, twoStar: 400, threeStar: 600),
                            filterGainDB: -10.0,
                            filterQ: 4.0,
                            octaveErrorRange: 2.0),
        
    ]

}
