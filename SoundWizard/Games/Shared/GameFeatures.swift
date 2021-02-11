//
//  GameFeatures.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/24/20.
//

import Foundation

// MARK: - Score Based

protocol ScoreBased {
    var turnScores: [Score] { get }
    var score: Int { get }
    var scoreMultiplier: ScoreMultiplier { get }
}

extension ScoreBased where Self: TurnBased {
    var turnScores: [Score] {
        turns.compactMap { $0.score }
    }
    
    var score: Int {
        Int(turns.compactMap { $0.score?.value }.reduce(0, +))
    }
}

// MARK: - Turn Based

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

// MARK: - Game Turn

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

// MARK: - Stage Based

protocol StageBased: TurnBased {
    var stage: Int { get }
    var turnsPerStage: Int { get }
    var baseErrorMultiplier: Double { get }
}

extension StageBased {
    var stage: Int {
       (turns.count - 1) / turnsPerStage
    }
}

extension StageBased where Self: ScoreBased {
    var guessErrorMultiplier: Octave {
        return pow(baseErrorMultiplier, Double(stage))
    }
}
