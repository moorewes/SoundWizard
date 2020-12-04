//
//  EQDetectiveGame.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/24/20.
//

import SwiftUI

class EQDetectiveGame: ObservableObject, GameModel {
    
    typealias TurnType = EQDetectiveTurn
    typealias ConductorType = EQDetectiveConductor
    
    // MARK: - Constants
    
    let testMode = false
    
    let startingLives = 2
    let maxLives = 3
    var timeBetweenTurns: Double { testMode ? 0.2 : 1.2 }
    
    private let multiplierStreakTarget = 4
    private let extraLifeStreakTarget = 3
    private let baseOctaveErrorMultiplier: Float = 0.7
    private let turnsPerStage = 5
    
    // MARK: - Properties
    
    // MARK: Bindings
    
    @Binding var gameViewState: GameViewState
    
    // MARK: Published
    
    @Published var selectedFreq: Frequency
    @Published var lives: Int
    @Published var scoreMultiplier: Float = 1
    
    @Published var extraLifeStreak = 0 {
        didSet {
            if extraLifeStreak > 0 && extraLifeStreak % extraLifeStreakTarget == 0 {
                scheduleAddExtraLife()
            }
        }
    }
    
    @Published private var turns = [EQDetectiveTurn]() {
        didSet {
            guard let turn = turns.last else { return }
            if let success = turn.score?.successLevel {
                extraLifeStreak += success >= .great ? 1 : -extraLifeStreak
                multiplierStreak += success >= .fair ? 1 : -multiplierStreak
                lives -= success <= .justMissed ? 1 : 0
            } else {
                conductor.set(filterFreq: turn.solution)
                filterOnState = 1
            }
        }
    }
    
    @Published var filterOnState: Int = 1 {
        didSet {
            let bypass = filterOnState == 0
            conductor.setFilterBypass(bypass)
        }
    }
    
    // MARK: Internal
    
    var level: EQDetectiveLevel
    
    var conductor: EQDetectiveConductor
    
    var score: Int {
        Int(turns.compactMap { $0.score?.value }.reduce(0, +))
    }
    
    var stage: Int {
        guard let currentTurn = currentTurn else { return 0 }
        
        let turnNumber = currentTurn.isComplete ? turns.count : turns.count - 1
        return turnNumber / (turnsPerStage)
    }
    
    var currentTurn: EQDetectiveTurn? {
        turns.last
    }
    
    var multiplierStreak = 0 {
        didSet {
            guard multiplierStreak > 0 else {
                scoreMultiplier = 1
                return
            }
            scoreMultiplier += multiplierStreak % multiplierStreakTarget == 0 ? 1 : 0
        }
    }
        
    var muted: Bool {
        conductor.isMuted
    }
    
    var showResultsView: Bool {
        currentTurn?.score != nil
    }
    
    var showGuessButton: Bool {
        currentTurn != nil && currentTurn?.score == nil
    }
    
    var solutionText: String {
        guard let answer = currentTurn?.solution else { return " " }
        return answer.decimalStringWithUnit
    }
    
    var feedbackText: String {
        guard let score = currentTurn?.score else { return "  " }
        return score.randomFeedbackString()
    }
        
    // MARK: Private
    
    private var octaveErrorRange: Octave {
        return level.octaveErrorRange * octaveErrorMultiplier
    }
        
    private var octaveErrorMultiplier: Octave {
        powf(baseOctaveErrorMultiplier, Float(stage))
    }
    
    // MARK: - Initializers
    
    init(level: EQDetectiveLevel, viewState: Binding<GameViewState>) {
        self.level = level
        _gameViewState = viewState
        conductor = EQDetectiveConductor(source: level.audioSource,
                                             filterGainDB: level.filterGainDB,
                                             filterQ: level.filterQ)
        
        selectedFreq = level.bandFocus.referenceFrequencies.centerItem!.uiRounded
        lives = startingLives
    }
    
    // MARK: - Intents
    
    func start() {
        conductor.startPlaying()
        startNewTurn()
    }
    
    func finish() {
        conductor.stopPlaying()
        level.updateProgress(score: score)
        gameViewState = .gameCompleted
        
        
    }
    
    func submitGuess() {
        endTurn()
    }
    
    // MARK: Private Methods
    
    private func startNewTurn() {
        turns.append(EQDetectiveTurn(number: turns.count + 1,
                                   octaveErrorRange: octaveErrorRange,
                                   solution: randomFrequency(),
                                   scoreMultiplier: scoreMultiplier))
    }
    
    private func endTurn() {
        let index = turns.endIndex - 1
        turns[index].finish(guess: selectedFreq)

        fireFeedback()
        
        scheduleEndOfTurnAction()
    }
    
    private func randomFrequency() -> Frequency {
        if testMode { return Float(1000) }
        return Frequency.random(in: level.bandFocus.range,
                                        disfavoring: turns.last?.solution,
                                        repelEdges: true)
    }
    
    private func scheduleEndOfTurnAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeBetweenTurns) {
            if self.lives < 0 {
                self.finish()
            } else {
                self.startNewTurn()
            }
        }
    }
    
    private func scheduleAddExtraLife() {
        guard lives < maxLives else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeBetweenTurns / 2) {
            self.lives += 1
            // TODO: Play sound
        }
    }
    
}

extension EQDetectiveGame: FrequencySliderDataSource {
    
    var frequencyRange: FrequencyRange {
        level.bandFocus.range
    }
    
    var octavesShaded: Float {
        level.octaveErrorRange * octaveErrorMultiplier * 2 
    }
    
    var solutionFreq: Frequency? {
        currentTurn?.solution
    }
    
    var solutionLineColor: Color {
        if let score = currentTurn?.score {
            return .successLevelColor(score.successLevel)
        }
        return .clear
    }
    
    var referenceFreqs: [Frequency] {
        return level.bandFocus.referenceFrequencies
    }
    
    
}
