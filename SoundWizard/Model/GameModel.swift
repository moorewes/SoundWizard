//
//  GameModel.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/25/20.
//

import SwiftUI


protocol StandardGame: GameModel, StageBased, ScoreBased, ScoreMultipliable, LivesBased {}

protocol GameModel: ObservableObject, GameStatusPublisher {
    
    associatedtype LevelType: Level
    associatedtype ConductorType: GameConductor
    
    var gameViewState: GameViewState { get set }
    var level: LevelType { get set }
    var gameConductor: ConductorType { get set }
    
    init(level: LevelType, gameViewState: Binding<GameViewState>)
    
    func fireFeedback()
    
}

extension GameModel where Self: TurnBased {
        
    func fireFeedback() {
        guard let successLevel = currentTurn?.score?.successLevel else {
            fatalError("Couldn't find score to fire feedback)")
        }
        
        Conductor.master.fireScoreFeedback(successLevel: successLevel)
        HapticGenerator.main.fire(successLevel: successLevel)
    }
    
}

protocol ScoreBased {
    
    var score: Int { get }
    
}

extension ScoreBased where Self: TurnBased {
    
    var score: Int {
        Int(turns.compactMap { $0.score?.value }.reduce(0, +))
    }
    
}


