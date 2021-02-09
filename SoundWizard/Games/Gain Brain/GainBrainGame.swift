//
//  GainBrainGame.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/8/21.
//

import SwiftUI

class GainBrainGame: ObservableObject, MultipleChoiceGame {
    let engine = Engine()
    let choicesCount = 4
    
    // MARK: Turns
    typealias TurnType = Turn
    
    let timeBetweenTurns = 2.0
    var turns: [Turn] = [] {
        didSet {
            
        }
    }
    
    // MARK: Scoring
    var scoreMultiplierValue: Double?
    
    // MARK: Lives
    var lives: Lives = Lives()
    
    // MARK: UI Data
    let instructionText: String = "How much gain has been applied?"
    
    @Published var auditionState: AuditionState = .before
    
    var choiceItems: [ChoiceItem] {
        guard let choices = currentTurn?.choices else { return [] }
        
        return choices.map { ChoiceItem(title: "\(Int($0.gain)) dB") }
    }
    
    // MARK: User Intents

    // MARK: Life Cycle
    
    func startGame() {
        turns.append(engine.newTurn(number: turns.count, choicesCount: choicesCount))
    }
    
}
