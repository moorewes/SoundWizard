//
//  GainBrainGame.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/8/21.
//

import SwiftUI

struct GainBrainGame: MultipleChoiceGame {
    var instructionText = "How much gain was applied?"
    var timeBetweenTurns: Double = 2.0
    var choicesCount = 2
    
    let conductor: GainBrainConductor
    var turns = [Turn]()
    var lives = Lives()
    var scoreMultiplier = ScoreMultiplier()
    
    var currentSolution: Choice? { currentTurn?.solution ?? nil }
    var currentChoices: [Choice] { currentTurn?.choices ?? [] }
    
    var auditionState = AuditionState.before {
        didSet {
            conductor.setDryWet(wet: auditionState == .after)
        }
    }
    
    // MARK: - Actions
    mutating func startPlaying() {
        conductor.startPlaying()
        startNewTurn()
    }
    
    mutating func startNewTurn() {
        turns.append(newTurn())
        conductor.setWetGain(currentSolution!.gain)
        conductor.changeAudio()
    }
    
    mutating func submitGuess(choice: Choice) {
        let score = self.score(choice: choice)
        turns[turns.count - 1].end(score: score)
        lives.update(for: score.successLevel)
        scoreMultiplier.update(for: score.successLevel)
        fireFeedback()
    }
    
    // MARK: - Initializer
    init(audio: [AudioMetadata]) {
        conductor = GainBrainConductor(audio: audio)
    }
    
    // MARK: - Helper Methods
    private mutating func newTurn() -> Turn {
        Turn(number: turns.count, choices: newChoices())
    }
    
    private mutating func newChoices() -> [Choice] {
        var options = Choice.possibleChoices.shuffled()
        var solution = options.removeLast()
        solution.isCorrect = true
        
        let gain = solution.gain
        options = options.filter { gain > 0 ? $0.gain > 0 : $0.gain < 0 }
        
        let choices = [solution] + options.shuffled().prefix(choicesCount - 1)
        return choices.shuffled()
    }
    
    private func score(choice: Choice) -> Score {
        let value = choice.isCorrect ? 100.0 : 0.0
        let success: ScoreSuccess = choice.isCorrect ? .perfect : .failed
        return Score(value: value, successLevel: success)
    }
}

// MARK: - Turn
extension GainBrainGame {
    struct Turn: MultipleChoiceGameTurn {
        var number: Int
        var choices: [GainBrainGame.Choice]
        var score: Score?
        var solution: GainBrainGame.Choice { choices.first { $0.isCorrect }! }
        
        mutating func end(score: Score) {
            self.score = score
        }
    }
}
