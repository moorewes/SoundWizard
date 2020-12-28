//
//  GameFeatures.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/24/20.
//

import Foundation

import Foundation

protocol ScoreBased {
    var turnScores: [Score] { get }
    var score: Int { get }
}

extension ScoreBased where Self: TurnBased {
    var turnScores: [Score] {
        turns.compactMap { $0.score }
    }
    
    var score: Int {
        Int(turns.compactMap { $0.score?.value }.reduce(0, +))
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

protocol GameTurn {
    var number: Int { get }
    var score: Score? { get }
    var isComplete: Bool { get }
}

extension GameTurn {
    var isComplete: Bool {
        return score != nil
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
