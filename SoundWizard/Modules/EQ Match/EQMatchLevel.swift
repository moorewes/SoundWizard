//
//  EQMatchLevel.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/6/20.
//

import Foundation

struct EQMatchLevel: Level {
    let game: Game = .eqMatch

    var id: String
    var number: Int
    var audioMetadata: [AudioMetadata]
    var difficulty: LevelDifficulty
    let format: Format
    
    // TODO: Implement
    var scoreData: ScoreData
    
    var staticFrequencies: [Frequency]?
    var staticGainValues: [Double]?
    
    lazy var guessError = GuessError(level: self)
}

extension EQMatchLevel {
    static func initialScoreData(difficulty: LevelDifficulty) -> ScoreData {
        var starScores = [Int]()
        switch difficulty {
        case .easy, .custom:
            starScores = [300, 500, 700]
        case .moderate:
            starScores = [500, 700, 900]
        case .hard:
            starScores = [700, 900, 1100]
        }
        
        return ScoreData(starScores: starScores)
    }
}
