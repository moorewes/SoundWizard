//
//  MultipleChoiceGame.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/8/21.
//

import Foundation

class MultipleChoiceGameViewModel<Game: MultipleChoiceGame>: ObservableObject {
    // MARK: - Game Model
    @Published var game: Game
    
    // MARK: - UI Properties
    var auditionState: AuditionState {
        get { game.auditionState }
        set { game.auditionState = newValue }
    }
    
    var statusProvider: GameStatusProviding { game }
    
    var choices: [Game.Choice] { game.currentChoices }
    
    var shouldRevealChoices: Bool {
        game.currentTurn?.isComplete ?? false
    }
    
    // MARK: - User Actions
    func startGame() {
        DispatchQueue.main.asyncAfter(deadline: .now() + game.timeBetweenTurns) {
            self.game.startPlaying()
        }
    }
    
    func choose(_ choice: Game.Choice) {
        guard !shouldRevealChoices else { return }
        
        game.submitGuess(choice: choice)
        startTurnTransition()
    }
    
    private func startTurnTransition() {
        DispatchQueue.main.asyncAfter(deadline: .now() + game.timeBetweenTurns) {
            self.game.startNewTurn()
            self.auditionState = .before
        }
    }
    
    // MARK: - Initializer
    init(game: Game) {
        self.game = game
        startGame()
    }
}
