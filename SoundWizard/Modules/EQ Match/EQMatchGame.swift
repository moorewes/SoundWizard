//
//  EQMatchGame.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/6/20.
//

import SwiftUI

class EQMatchGame: ObservableObject, StandardGame {
    typealias ConductorType = EQMatchConductor
    typealias TurnType = Turn
    
    var level: EQMatchLevel
    var conductor: EQMatchConductor?
    @Published var filterData = [EQBellFilterData]() {
        didSet {
            conductor?.update(data: filterData)
        }
    }
    var turns = [Turn]()
    var practicing: Bool

    var turnsPerStage = 5
    var timeBetweenTurns: Double = 1.2
    var scoreMultiplier = ScoreMultiplier()
    var lives = Lives()
    
    init(level: EQMatchLevel, practice: Bool, completionHandler: GameCompletionHandling) {
        self.level = level
        self.practicing = practice
        self.filterData = level.initialFilterData
        self.conductor = EQMatchConductor(source: level.audioMetadata[0], filterData: filterData)
        
        conductor?.startPlaying()
    }
    
}

extension EQMatchGame {
    struct Turn: GameTurn {
        var number: Int
        var score: TurnScore?
    }
}

struct EQMatchLevel: Level {
    var id: String
    var game: Game
    var number: Int
    var audioMetadata: [AudioMetadata]
    var difficulty: LevelDifficulty
    var scoreData: ScoreData
    
    var bandFocus: BandFocus
    let filterCount: Int
    let changesFrequency: Bool
}
