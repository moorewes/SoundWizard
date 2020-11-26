//
//  EQDetectiveGame.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/24/20.
//

import SwiftUI

class EQDetectiveGame: ObservableObject, GameModel {
    
    typealias TurnType = EQDetectiveTurn
    typealias ConductorType = EqualizerFilterConductor
    
    var level: EQDetectiveLevel
    
    var conductor: EqualizerFilterConductor
    
    @Published private var turns = [EQDetectiveTurn]()
    @Published var isMuted = false
    
    // TODO: Game starts with filter bypassed for some reason
    @Published var filterOnState: Int = 1 {
        didSet {
            let bypass = filterOnState == 0
            conductor.setFilterBypass(bypass)
        }
    }
    
    @Binding var gameViewState: GameViewState
    
    var currentTurn: EQDetectiveTurn? {
        turns.last
    }
    
    var score: Int {
        Int(turns.compactMap { $0.score?.value }.reduce(0, +))
    }
    
    var completion: Float {
        let completedTurns = turns.filter { $0.isComplete }.count
        return Float(completedTurns) / Float(level.numberOfTurns)
    }
    
    var muted: Bool { conductor.isMuted }
        
    private(set) var selectedFreq: Frequency = 1000.0
    
    var freqSliderValue: CGFloat {
        let octave = selectedFreq.asOctave
        return CGFloat(octave / level.octavesVisible)
    }
    
    lazy var freqSliderRange: ClosedRange<CGFloat> = {
        let octaveRange = AudioMath.octaveRange(from: level.freqGuessRange,
                                                decimalPlaces: 2)
        let lowerBound = octaveRange.lowerBound / level.octavesVisible
        let upperBound = octaveRange.upperBound / level.octavesVisible
        
        return CGFloat(lowerBound)...CGFloat(octaveRange.upperBound)
    }()
    
    var showResultsView: Bool {
        currentTurn?.score != nil
    }
    
    var showGuessButton: Bool {
        currentTurn != nil && currentTurn?.score == nil
    }
    
    var solutionText: String {
        guard let answer = currentTurn?.solution else { return "" }
        return answer.decimalString
    }
    
    var feedbackText: String {
        guard let score = currentTurn?.score else { return "  " }
        return score.randomFeedbackString()
    }
    
    // MARK: - Initializers
    
    init(level: EQDetectiveLevel, viewState: Binding<GameViewState>) {
        self.level = level
        _gameViewState = viewState
        conductor = EqualizerFilterConductor(source: level.audioSource,
                                             filterGainDB: level.filterGainDB,
                                             filterQ: level.filterQ)
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
    
    func freqSliderChanged(to freq: Frequency) {
        selectedFreq = freq
    }
    
    func toggleMute() {
        isMuted.toggle()
        conductor.toggleMute()
    }
    
    // MARK: Private Methods
    
    private func startNewTurn() {
        let turn = EQDetectiveTurn(number: turns.count + 1, level: level, previousTurn: turns.last)
        turns.append(turn)
        conductor.set(filterFreq: turn.solution)
        filterOnState = 1
    }
    
    private func endTurn() {
        let index = turns.endIndex - 1
        turns[index].finish(guess: selectedFreq)
        
        fireFeedback()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if self.turns.count == self.level.numberOfTurns {
                self.finish()
            } else {
                self.startNewTurn()
            }
        }
    }
    
}
