//
//  EQDetectiveGame.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/24/20.
//

import SwiftUI

class EQDetectiveGame: ObservableObject, StandardGame {
    typealias TurnType = EQDetectiveTurn
    typealias ConductorType = EQDetectiveConductor
    
    // MARK: - Constants
    
    let testMode = false // TODO: - Remove for production
    var practicing: Bool
    let turnsPerStage = 5
    var timeBetweenTurns: Double { testMode ? 0.2 : 1.2 }
    var completionHandler: GameCompletionHandling
    
    private let baseOctaveErrorMultiplier: Double = 0.7
    
    // MARK: - Properties

    // MARK: Published
    
    @Published var selectedFreq: Frequency {
        didSet {
            if inBetweenTurns && practicing {
                gameConductor.set(filterFreq: selectedFreq.auValue)
            }
        }
    }
    
    @Published var turns = [EQDetectiveTurn]() {
        didSet {
            guard let turn = turns.last else { return }
            if let score = turn.score {
                lives.update(for: score.successLevel)
                scoreMultiplier.update(for: score.successLevel)
                feedbackText = score.randomFeedbackString()
            } else {
                filterOnState = 1
                gameConductor.set(filterFreq: turn.solution.auValue)
            }
        }
    }
    
    @Published var filterOnState: Int = 1 {
        didSet {
            let bypass = filterOnState == 0
            if oldValue != filterOnState {
                gameConductor.setFilterBypass(bypass)
            }
        }
    }
    
    @Published var feedbackText: String = " "
    
    // MARK: Internal
    
    var level: EQDLevel
    var gameConductor: EQDetectiveConductor
    var masterConductor = Conductor.master
    var lives: Lives
    var scoreMultiplier: ScoreMultiplier
        
    var muted: Bool {
        gameConductor.isMuted
    }
            
    var inBetweenTurns: Bool {
        currentTurn?.isComplete ?? false
    }
    
    var showSubmitButton: Bool {
        return currentTurn != nil && currentTurn?.score == nil
    }
    
    var showContinueButton: Bool {
        return practicing && inBetweenTurns
    }
    
    var solutionText: String {
        guard let answer = currentTurn?.solution else { return " " }
        return answer.decimalStringWithUnit
    }
        
    // MARK: Private
    
    private var octaveErrorRange: Octave {
        return level.octaveErrorRange * octaveErrorMultiplier
    }
        
    private var octaveErrorMultiplier: Octave {
        return pow(baseOctaveErrorMultiplier, Double(stage))
    }
    
    // MARK: - Initializers
    
    init(level: EQDLevel, practice: Bool, completionHandler: GameCompletionHandling) {
        self.level = level
        self.completionHandler = completionHandler
        self.practicing = practice
        scoreMultiplier = ScoreMultiplier()
        
        lives = Lives()
        
        gameConductor = EQDetectiveConductor(source: level.audioMetadata[0],
                                             filterGain: level.filterGain,
                                             filterQ: level.filterQ.auValue)
        
        selectedFreq = level.bandFocus.referenceFrequencies.centerItem!.uiRounded
    }
    
    // MARK: - Intents
    
    func start() {
        gameConductor.startPlaying()
        startNewTurn()
    }
    
    func finish() {
        let gameScore = GameScore(turnScores: turnScores)
        completionHandler.finish(score: gameScore)
    }
    
    func stopAudio() {
        gameConductor.stopPlaying()        
    }
    
    func submitGuess() {
        endTurn()
    }
    
    func continueToNextTurn() {
        startNewTurn()
    }
    
    func toggleFilterOnState() {
        filterOnState = filterOnState == 0 ? 1 : 0
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
        if testMode { return Frequency(1000) }
        return Frequency.random(in: level.bandFocus.range,
                                        disfavoring: turns.last?.solution,
                                        repelEdges: true)
    }
    
    private func scheduleEndOfTurnAction() {
        guard !practicing else { return }
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
    
    var octavesShaded: Double {
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
