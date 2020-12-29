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
    
    var practicing: Bool
    var completionHandler: GameCompletionHandling

    var turnsPerStage = 5
    var timeBetweenTurns: Double = 1.2
    private let baseOctaveErrorMultiplier: Double = 0.7
    
    var scoreMultiplier = ScoreMultiplier()
    var lives = Lives()
    
    @Published var turns = [Turn]()
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
        case .bypassed, .guess:
            return guessFilterData
        case .solution:
            return solutionFilterData
        }
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
        showingResults ? "NEXT" : "SUBMIT"
    }
    
    // MARK: Private
    
    private var maxGuessError: EQMatchLevel.GuessError {
        level.guessError.applyingMultiplier(guessErrorMultiplier)
    }
    
    // TODO: Can probably be refactored to default protocol implementation
    private var guessErrorMultiplier: Octave {
        return pow(baseOctaveErrorMultiplier, Double(stage))
    }
    
    init(level: EQMatchLevel, practice: Bool, completionHandler: GameCompletionHandling) {
        self.level = level
        self.practicing = practice
        self.guessFilterData = level.initialFilterData
        self.completionHandler = completionHandler
        self.conductor = EQMatchConductor(source: level.audioMetadata[0],
                                          filterData: guessFilterData.auData)
        
        startTurn()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.conductor?.startPlaying()
        }
    }
    
    // MARK: - Methods
    
    // MARK: User Actions
    
    func startTurn() {
        let solution = newSolution()
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
        if showingResults {
            startTurn()
        } else {
            endTurn()
        }
    }
    
    func finish() {
        let gameScore = GameScore(turnScores: turnScores)
        completionHandler.finish(score: gameScore)
    }
    
    // MARK: Private Methods
    
    // TODO: Prevent adjacent bands from generating random frequencies that are close
    private func newSolution() -> [EQBellFilterData] {
        var solution = guessFilterData
        for i in 0..<solution.count {
            solution[i].shuffleGain()
            if level.variesFrequency {
                solution[i].shuffleFrequency()
            }
        }
        
        return solution
    }
    
}

private extension EQBellFilterData {
    mutating func shuffleGain() {
        let randomInt = Int.random(in: Int(dBGainRange.lowerBound)...Int(dBGainRange.upperBound))
        gain.dB = Double(randomInt)
    }
    
    mutating func shuffleFrequency() {
        let freq = Frequency.random(in: frequencyRange, disfavoring: frequency, repelEdges: true)
        frequency = freq
    }
}
