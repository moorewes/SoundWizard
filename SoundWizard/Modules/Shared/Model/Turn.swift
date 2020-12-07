//
//  Turn.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/25/20.
//

import Foundation

protocol GameTurn {
    
    var number: Int { get }
    var score: TurnScore? { get }
    var isComplete: Bool { get }
    
}

extension GameTurn {
    
    var isComplete: Bool {
        return score != nil
    }
    
}

protocol TurnBased {
    
    associatedtype TurnType: GameTurn
    
    var currentTurn: TurnType? { get }
    var turns: [TurnType] { get set }
    var timeBetweenTurns: Double { get }
    
}

extension TurnBased  {
    
    var currentTurn: TurnType? {
        return turns.last
    }
    
}

protocol StageBased: TurnBased {
    
    var stage: Int { get }
    var turnsPerStage: Int { get }
    
}

extension StageBased {
    var stage: Int {
       (turns.count - 1) / turnsPerStage
    }
}

