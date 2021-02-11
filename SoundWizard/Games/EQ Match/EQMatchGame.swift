//
//  EQMatchGame.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/6/20.
//

import SwiftUI

class EQMatchGame: ObservableObject, GameModel {
    typealias ConductorType = EQMatchConductor
    typealias TurnType = Turn
    
    let isPracticing: Bool
    let completionHandler: GameCompletionHandling
    
    var level: EQMatchLevel
    var engine: Engine
    var conductor: EQMatchConductor?
    var scoreMultiplier = ScoreMultiplier()
    var lives = Lives()
    
    // MARK: Published Properties
        
    @Published var turns = [Turn]() {
        didSet {
            guard let turn = turns.last else { return }
            if let score = turn.score {
                lives.update(for: score.successLevel)
                scoreMultiplier.update(for: score.successLevel)
            } else {
                filterMode = .solution
            }
        }
    }
        
    @Published var rawGuess = [EQBellFilterData]() {
        didSet {
            conductor?.update(guess: rawGuess.roundingFreqs.auData)
        }
    }
    
    @Published var filterMode: FilterMode = .solution {
        didSet {
            conductor?.set(filterMode: filterMode)
        }
    }
    
    // MARK: - Initializer
    
    init(level: EQMatchLevel,
         practice: Bool,
         completionHandler: GameCompletionHandling,
         conductor: EQMatchConductor? = nil) {
        self.level = level
        self.engine = Engine(level: level)
        self.isPracticing = practice
        self.completionHandler = completionHandler
        self.conductor = EQMatchConductor(source: level.audioMetadata[0],
                                          filterData: level.normalledFilterData.auData)
        
        startTurn()
        DispatchQueue.main.asyncAfter(deadline: .now() + Parameters.gameStartDelay) {
            self.conductor?.startPlaying()
        }
    }
        
    // MARK: - User Actions
    
    func action() {
        if lives.isDead {
            finish()
        } else if showingResults {
            startTurn()
        } else {
            endTurn()
        }
    }
    
    func finish() {
        let gameScore = GameScore(turnScores: turnScores)
        completionHandler.finish(score: gameScore)
    }
    
    func stopAudio() {
        conductor?.stopPlaying()
    }
}

// MARK: Turns

extension EQMatchGame: TurnBased {
    var timeBetweenTurns: Double { Parameters.timeBetweenTurns }
    
    func startTurn() {
        let data = engine.newTurn()
        conductor?.update(solution: data.solution.auData)
        rawGuess = data.baseGuess
        
        let error = level.guessError.applyingMultiplier(guessErrorMultiplier)
        turns.append(Turn(number: turns.count, solution: data.solution, guessError: error))
        
        filterMode = .solution
    }
    
    func endTurn() {
        turns[turns.count - 1].endTurn(guess: rawGuess)
        fireFeedback()
    }
}

// MARK: - View Properties

extension EQMatchGame {
    var solutionFilterData: [EQBellFilterData] {
        turns.last!.solution
    }
    
    var displayedFilterData: [EQBellFilterData] {
        guard showingResults else { return rawGuess }
        
        switch filterMode {
        case .guess:
            return rawGuess
        case .solution:
            return solutionFilterData
        }
    }
    
    var frequencyRange: FrequencyRange {
        level.format.bandFocus.range
    }
    
    var gainRange: ClosedRange<Double> {
        Parameters.fullGainRange
    }
    
    var turnResult: Turn.Result? {
        currentTurn?.result
    }
    
    var solutionLineColor: Color {
        guard let successLevel = turnResult?.score.successLevel else {
            return .clear
        }
        return Color.successLevelColor(successLevel)
    }
    
    var showingResults: Bool {
        currentTurn?.isComplete ?? false
    }
    
    var actionButtonTitle: String {
        !showingResults ? "SUBMIT" : lives.isDead ? "FINISH" : "NEXT"
    }
}

// MARK: - Stages

extension EQMatchGame: StageBased {
    var turnsPerStage: Int { Parameters.turnsPerStage }
    var baseErrorMultiplier: Double { Parameters.baseErrorMultiplier }
}

// MARK: - Filter Mode

extension EQMatchGame {
    enum FilterMode: String, CaseIterable, Identifiable {
        case solution, guess
        
        var id: String { rawValue }
    }
}
