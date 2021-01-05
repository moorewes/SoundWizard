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
    var solutions: SolutionGenerator
    var conductor: EQMatchConductor?
    let isPracticing: Bool
    let completionHandler: GameCompletionHandling
    var scoreMultiplier = ScoreMultiplier()
    var lives = Lives()
    
    let gameStartDelay = 1.0
    let turnsPerStage = 5
    var timeBetweenTurns: Double = 1.2
    private let baseOctaveErrorMultiplier: Double = 0.7
    
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
    
    @Published var solutionFilterData = [EQBellFilterData]()
    
    @Published var guessFilterData = [EQBellFilterData]() {
        didSet {
            conductor?.update(guess: guessFilterData.auData)
        }
    }
    
    @Published var filterMode: FilterMode = .solution {
        didSet {
            conductor?.set(filterMode: filterMode)
        }
    }
    
    var displayedFilterData: [EQBellFilterData] {
        guard showingResults else { return guessFilterData }
        
        switch filterMode {
        case .guess:
            return guessFilterData
        case .solution:
            return solutionFilterData
        }
    }
    
    var frequencyRange: FrequencyRange {
        level.format.bandFocus.range
    }
    
    // TODO: Determine whether this is constant for all levels
    var gainRange: ClosedRange<Double> {
        return solutions.fullGainRange
    }
    
    var turnResult: Turn.Result? {
        turns.last?.result
    }
    
    var solutionLineColor: Color {
        guard let successLevel = turnResult?.score.successLevel else {
            return .clear
        }
        return Color.successLevelColor(successLevel)
    }
    
    var showingResults: Bool {
        turns.last?.isComplete ?? false
    }
    
    var actionButtonTitle: String {
        !showingResults ? "SUBMIT" : lives.isDead ? "FINISH" : "NEXT"
    }
    
    // MARK: Private
    
    private var maxGuessError: EQMatchLevel.GuessError {
        level.guessError.applyingMultiplier(guessErrorMultiplier)
    }
    
    // TODO: Can probably be refactored to default protocol implementation
    private var guessErrorMultiplier: Octave {
        return pow(baseOctaveErrorMultiplier, Double(stage))
    }
    
    init(level: EQMatchLevel,
         practice: Bool,
         completionHandler: GameCompletionHandling,
         conductor: EQMatchConductor? = nil) {
        self.level = level
        self.solutions = SolutionGenerator(level: level)
        self.isPracticing = practice
        self.guessFilterData = solutions.solutionTemplate
        self.completionHandler = completionHandler
        self.conductor = EQMatchConductor(source: level.audioMetadata[0],
                                              filterData: guessFilterData.auData)
        
        startTurn()
        DispatchQueue.main.asyncAfter(deadline: .now() + gameStartDelay) {
            self.conductor?.startPlaying()
        }
    }
    
    // MARK: - Methods
    
    // MARK: User Actions
    
    func startTurn() {
        let solution = solutions.nextSolution()
        resetGuessData(for: solution)
        conductor?.update(solution: solution.auData)
        turns.append(Turn(number: turns.count, solution: solution, guessError: maxGuessError))
        solutionFilterData = solution
        filterMode = .solution
    }
    
    func endTurn() {
        turns[turns.count - 1].endTurn(guess: guessFilterData)
        fireFeedback()
    }
    
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
    
    // MARK: Private Methods
    
    private func resetGuessData(for solution: [EQBellFilterData]) {
        guessFilterData = solutions.solutionTemplate.enumerated().map { (index, filter) in
            var filter = filter
            
            switch level.format.mode {
            case .fixedGain:
                let gain = solution[index].gain
                filter.gain = gain
                filter.dBGainRange = gain.dB...gain.dB
            default:
                break
            }
            
            return filter
        }
    }
}
