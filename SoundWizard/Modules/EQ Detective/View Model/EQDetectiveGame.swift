//
//  EQDetectiveGame.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/24/20.
//

import SwiftUI


class EQDetectiveGame: StandardGame {
    
    typealias TurnType = EQDetectiveTurn
    typealias ConductorType = EQDetectiveConductor
    
    // MARK: - Constants
    
    let testMode = true // TODO: - Remove for production
    
    let turnsPerStage = 5
    var timeBetweenTurns: Double { testMode ? 0.2 : 1.2 }
    
    private let baseOctaveErrorMultiplier: Float = 0.7
    
    // MARK: - Properties
    
    // MARK: Bindings
    
    @Binding var gameViewState: GameViewState
    
    // MARK: Published
    
    @Published var selectedFreq: Frequency
    
    @Published var turns = [EQDetectiveTurn]() {
        didSet {
            guard let turn = turns.last else { return }
            if let success = turn.score?.successLevel {
                lives.update(for: success)
                scoreMultiplier.update(for: success)
            } else {
                gameConductor.set(filterFreq: turn.solution)
                filterOnState = 1
            }
        }
    }
    
    @Published var filterOnState: Int = 1 {
        didSet {
            let bypass = filterOnState == 0
            gameConductor.setFilterBypass(bypass)
        }
    }
    
    // MARK: Internal
    
    var level: EQDetectiveLevel
    var gameConductor: EQDetectiveConductor
    var masterConductor = Conductor.master
    var lives: Lives
    var scoreMultiplier: ScoreMultiplier
        
    var muted: Bool {
        gameConductor.isMuted
    }
    
    var showResultsView: Bool {
        currentTurn?.isComplete ?? false
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
        return powf(baseOctaveErrorMultiplier, Float(stage))
    }
    
    // MARK: - Initializers
    
    required init(level: EQDetectiveLevel, gameViewState: Binding<GameViewState>) {
        self.level = level
        _gameViewState = gameViewState
        
        scoreMultiplier = ScoreMultiplier()
        
        lives = Lives()
        
        gameConductor = EQDetectiveConductor(source: level.audioMetadata[0],
                                             filterGainDB: level.filterGainDB,
                                             filterQ: level.filterQ)
        
        selectedFreq = level.bandFocus.referenceFrequencies.centerItem!.uiRounded
    }
    
    // MARK: - Intents
    
    func start() {
        gameConductor.startPlaying()
        startNewTurn()
    }
    
    func finish() {
        level.scores.append(score)
        gameViewState = .gameCompleted
    }
    
    func stopAudio() {
        gameConductor.stopPlaying()        
    }
    
    func submitGuess() {
        endTurn()
    }
    
    // MARK: Private Methods
    
    private func startNewTurn() {
        turns.append(EQDetectiveTurn(number: turns.count + 1,
                                   octaveErrorRange: octaveErrorRange,
                                   solution: randomFrequency(),
                                   scoreMultiplier: scoreMultiplier.value))
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
            if self.remainingLives < 0 {
                self.finish()
            } else {
                self.startNewTurn()
            }
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
