//
//  StateController.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/15/20.
//

import SwiftUI

// TODO: Make dynamic for other level types
class StateController: ObservableObject {
    
    // TODO: Create fetcher protocol to allow stores other than core data
    private let dataManager = CoreDataManager.shared
    
    private var allLevels = [Level]()
    
    @Published var dailyLevels: [Level]
    @Published var gameState: GameViewState
    @Published var gameHandler: GameHandler?
    
    var isPresentingLevel: Bool {
        get {
            return gameHandler != nil
        }
        set {
            gameHandler = nil
        }
    }
    
    var gameItems: [GameItem] {
        Game.allCases.map { game in
            let stars = levels(for: game).stars
            return GameItem(game: game, stars: stars)
        }
    }
    
    init() {
        allLevels = dataManager.allLevels()
        dailyLevels = allLevels.filter { $0.number < 5 }
        gameState = .none
    }
    
    func playLevel(_ level: Level) {
        if let level = self.level(matching: level) {
            gameHandler = GameHandler(level: level,
                                      state: gameState,
                                      startHandler: self,
                                      completionHandler: self)
        } else {
            fatalError("Could not find level to select for play")
        }
    }
    
    func index(for level: Level) -> Int? {
        allLevels.firstIndex { $0.id == level.id }
    }
    
    func levels(for game: Game) -> [Level] {
        allLevels.filter { $0.game == game }
    }
    
    func levels<T: Level>() -> [T] {
        allLevels.compactMap { $0 as? T }
    }
    
    private func level(matching level: Level) -> Level? {
        allLevels.first { $0.id == level.id }
    }

}

// MARK: - Game Handling

extension StateController: GameTransitionHandling {
    
    struct GameHandler: GameHandling {
        var level: Level
        var state: GameViewState
        private(set) var startHandler: GameStartHandling
        private(set) var completionHandler: GameCompletionHandling
    }
    
    func startGame(practicing: Bool) {
        gameHandler?.state = .inGame(practicing: practicing)
    }
    
    // TODO: Store score success array for useful statistics
    func finishGame(score: GameScore) {
        guard let level = gameHandler?.level,
              let index = index(for: level)  else { return }
        allLevels[index].scoreData.addScore(score.value)
        gameHandler?.state = .gameCompleted
        gameHandler?.level = allLevels[index]
        
        dataManager.update(from: allLevels[index])
    }
    
    func quitGame() {
        switch gameHandler?.state {
        case .inGame(_):
            gameHandler?.state = .gameQuitted
        default:
            returnToMenu()
        }
    }
    
    private func returnToMenu() {
        gameHandler = nil
    }
        
}
