//
//  EQMatchGame.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/6/20.
//

import SwiftUI

class EQMatchGame: StandardGame {
    typealias LevelType = EQMatchLevel
    typealias ConductorType = EQMatchConductor
    
    @Binding var gameViewState: GameViewState
    
    var turnsPerStage = 5
    var timeBetweenTurns: Double = 1.0
    
    var scoreMultiplier: ScoreMultiplier
    var level: EQMatchLevel
    var conductor: EQMatchConductor
    
    var turns: [Turn] = []
    
    var lives: Lives
        
    required init(level: EQMatchLevel, gameViewState: Binding<GameViewState>) {
        self.level = level
        self._gameViewState = gameViewState
        self.conductor = EQMatchConductor(source: level.audioSource)
        self.lives = Lives()
        self.scoreMultiplier = ScoreMultiplier()
    }
}

extension EQMatchGame {
    typealias TurnType = Turn
    
    struct Turn: GameTurn {
        var number: Int
        var score: TurnScore?
    }
}

class EQMatchLevel: Level {
    var game = Game.eqMatch
    var progressManager = UserProgressManager.shared
    
    lazy var progress: LevelProgress = {
        let progress = progressManager.progress(for: self)
        progress.updateStarsEarned(starScores: starScores)
        return progress
    }()
        
    var levelNumber: Int
    
    var audioSource: audioSource
    
    var starScores: [Int]
        
    var difficulty: LevelDifficulty
    
    var description: String
    
    init(number: Int, audioSource: AudioFile, difficulty: LevelDifficulty) {
        self.levelNumber = number
        self.audioSource = audioSource
        self.difficulty = difficulty
        self.description = ""
        self.starScores = Self.starScores(for: difficulty)
    }
    
    func updateProgress(score: Int) {
        
    }
}

extension EQMatchGame: InteractiveFilterDataSource {
    var solutionGain: Float {
        AudioMath.dBToPercent(dB: 3)
    }
    
    var frequencyRange: FrequencyRange {
        return BandFocus.mid.range
    }
    
    var octavesShaded: Float {
        return 0.5
    }
    
    var solutionFreq: Frequency? {
        return 1000
    }
    
    var solutionLineColor: Color {
        .green
    }
    
    var referenceFreqs: [Frequency] {
        BandFocus.mid.referenceFrequencies
    }
    
    var filterQ: Float {
        4.0
    }
}

extension EQMatchLevel {
    static func starScores(for difficulty: LevelDifficulty) -> [Int] {
        switch difficulty {
        case .easy:
            return [300, 500, 700]
        case .moderate:
            return [400, 600, 800]
        case .hard:
            return [500, 700, 900]
        }
    }
}

extension EQMatchLevel {
    static let levels: [EQMatchLevel] = [
        EQMatchLevel(number: 1, audioSource: .acousticDrums, difficulty: .easy)
    ]
}
