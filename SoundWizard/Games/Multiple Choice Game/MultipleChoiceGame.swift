//
//  MultipleChoiceGame.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/10/21.
//

import Foundation

protocol MultipleChoiceGame: GameStatusProviding, ScoreBased, LivesBased, TurnBased {
    associatedtype Choice: MultipleChoiceGameChoice
    
    var auditionState: AuditionState { get set }
    var currentChoices: [Choice] { get }
    var timeBetweenTurns: Double { get }
    
    mutating func startPlaying()
    mutating func startNewTurn()
    mutating func submitGuess(choice: Choice)
}

protocol MultipleChoiceGameTurn: GameTurn {
    associatedtype Choice: MultipleChoiceGameChoice
    var choices: [Choice] { get }
    mutating func end(score: Score)
}

protocol MultipleChoiceGameChoice: Identifiable, Equatable {
    var title: String { get }
    var isCorrect: Bool { get }
}
