//
//  EQDetectiveViewModel.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/9/20.
//

import Foundation
import SwiftUI

class EQDetectiveViewModel: ObservableObject, GameViewModeling, EQDetectiveEngineDelegate {
    
    var engine: EQDetectiveEngine
    var level: Level
    
    var completionHandler: (() -> Void)?
            
    @Published var gameState = EQDetectiveGameState.awaitingGuess
    @Published var turnNumber: Int = 0
    @Published var octaveErrorRange: Float = 2.0
    @Published var octaveCount: Float = 10.0
    @Published var score: Int = 0
    @Published var answerFreq: Float?
    @Published var feedbackLabelText: String = "Nice"
    @Published var successColor: Color = Color.green
    
    @Published var filterOnState: Int = 1 {
        didSet {
        engine.toggleFilter(bypass: filterOnState == 0)
        }
    }
    
    @Published var audioShouldPlay = true {
        didSet {
            engine.toggleMute(mute: !audioShouldPlay)
        }
    }
    
    lazy var freqSliderPercentageRange: ClosedRange<CGFloat> = {
        let range = (level as! EQDetectiveLevel).freqGuessRange
        
        let minFreq = range.lowerBound
        let minOctave = AudioCalculator.octave(fromFreq: minFreq, decimalPlaces: 2)
        let minPercentage = CGFloat(minOctave / octaveCount)
        
        let maxFreq = range.upperBound
        let maxOctave = AudioCalculator.octave(fromFreq: maxFreq, decimalPlaces: 2)
        let maxPercentage = CGFloat(maxOctave / octaveCount)
        
        return minPercentage...maxPercentage
    }()
    
    var freqSliderPercentage: CGFloat = 0.5 {
        didSet {
            if gameState == .showingResults {
                engine.previewFreq(selectedFreq)
            }
        }
    }

    var answerOctave: Float? {
        guard let answer = answerFreq,
              showResultsView else { return nil }
        return AudioCalculator.octave(fromFreq: answer)
    }
    
    var showResultsView: Bool {
        return gameState == .showingResults || gameState == .endOfRound
    }
    
    var answerFreqString: String {
        guard let answer = answerFreq else { return "" }
        return answer.freqDecimalString
    }
    
    var octaveErrorString: String {
        guard let octaveError = engine.currentTurn?.octaveError else { return "" }
        return octaveString(octaveError)
    }
    
    var selectedFreq: Float {
        let octave = Float(10 * freqSliderPercentage)
        return AudioCalculator.freq(fromOctave: octave)
    }
    
    var roundProgress: Double {
        let turns = level.numberOfTurns
        let turn = gameState == .awaitingGuess ? turnNumber : turnNumber + 1
        return Double(turn) / Double(turns)
    }
    
    var proceedButtonLabelText: String {
        switch gameState {
        case .notStarted:
            return "Start"
        case .awaitingGuess:
            return "Submit"
        case .showingResults:
            return "Next"
        case .endOfRound:
            return "Finish"
        }
    }
    
    // MARK: Initializers
    
    init(level: Level) {
        self.level = level
        engine = EQDetectiveEngine(level: level as! EQDetectiveLevel)
        engine.delegate = self
    }
    
    deinit {
        print("discarded vm")
    }

    func viewDidAppear() {
        engine.startNewRound()
    }
    
    func didTapProceedButton(completion: @escaping () -> Void) {
        completionHandler = completion
        switch gameState {
        case .notStarted:
            engine.startNewRound()
        case .awaitingGuess:
            engine.submitGuess(selectedFreq)
        case .showingResults:
            engine.startNewTurn()
        case .endOfRound:
            engine.stop()
        }
    }
    
    // MARK: Level Modeling Conformance
    
    func cancelGameplay() {
        engine.quitRound()
    }
    
    // MARK: EQDetective Engine Delegate Methods
    
    func roundDidBegin() {
        score = 0
        gameState = .awaitingGuess
    }
    
    func turnDidBegin(turn: EQDetectiveTurn) {
        answerFreq = turn.freqSolution
        turnNumber = turn.number
        gameState = .awaitingGuess
    }
    
    func turnDidEnd(turnScore: EQDetectiveTurnScore, totalScore: Int) {
        score = totalScore
        
        fireFeedback(successLevel: turnScore.successLevel)
        
        feedbackLabelText = turnScore.randomFeedbackString()
        successColor = feedbackLabelColor(for: turnScore.successLevel)
        gameState = .showingResults
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [unowned self] in
            if self.gameState == .endOfRound {
                self.completionHandler?()
            } else {
                self.engine.startNewTurn()
            }
            
        }
    }
    
    func roundDidEnd(round: EQDetectiveRound) {
        gameState = .endOfRound
        engine.stop()
    }
    
    private func octaveString(_ octave: Float) -> String {
        var text = "\(octave) Octave"
        if abs(octave) != 1 {
            text.append("s")
        }
        return text
    }
    
    private func feedbackLabelColor(for success: ScoreSuccessLevel) -> Color {
        switch success {
        case .failed, .justMissed:
            return Color.red
        case .fair:
            return Color.yellow
        case .great, .perfect:
            return Color.green
        }
    }
    
}
