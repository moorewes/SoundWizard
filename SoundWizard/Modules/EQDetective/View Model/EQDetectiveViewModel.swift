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
    
    typealias ViewType = EQDetectiveGameplayView
    
    @Published var state = EQDetectiveGameState.awaitingGuess {
        didSet {
            print(state)
        }
    }
    @Published var turnNumber: Int = 1
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
    
    var freqSliderPercentage: CGFloat = 0.5 {
        didSet {
            if state == .showingResults {
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
        return state == .showingResults || state == .endOfRound
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
    
    var proceedButtonLabelText: String {
        switch state {
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

    func viewDidAppear() {
        engine.startNewRound()
    }
    
    func didTapProceedButton() {
        switch state {
        case .notStarted:
            engine.startNewRound()
        case .awaitingGuess:
            engine.submitGuess(selectedFreq)
            print(selectedFreq)
        case .showingResults:
            engine.startNewTurn()
        case .endOfRound:
            engine.stop()
        }
    }
    
    // MARK: Level Modeling Conformance
    
    func cancelGameplay() {
        engine.stop()
    }
    
    // MARK: EQDetective Engine Delegate Methods
    
    func roundDidBegin() {
        state = .awaitingGuess
    }
    
    func turnDidBegin(turn: EQDetectiveTurn) {
        answerFreq = turn.freqSolution
        turnNumber = turn.number + 1
        state = .awaitingGuess
    }
    
    func turnDidEnd(score: EQDetectiveTurnScore) {
        self.score += Int(score.value)
        feedbackLabelText = score.randomFeedbackString()
        successColor = feedbackLabelColor(for: score.successLevel)
        state = .showingResults
    }
    
    func roundDidEnd(round: EQDetectiveRound) {
        state = .endOfRound
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
