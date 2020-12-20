//
//  StateController.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/15/20.
//

import SwiftUI

// TODO: Make dynamic for other level types
class StateController: ObservableObject {
    
    private let levelStore: LevelFetching & LevelStoring
    
    private var allLevels = [Level]()
    var dailyLevels: [Level] {
        return allLevels.filter { $0.number < 5}
    }
    
    @Published var gameState: GameViewState = .none
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
    
    init(levelStore: LevelFetching & LevelStoring) {
        self.levelStore = levelStore
        allLevels = levelStore.fetchLevels(for: .eqDetective)
    }
    
    func openLevel(_ level: Level) {
        if let level = self.level(matching: level) {
            gameHandler = GameHandler(level: level,
                                      state: gameState,
                                      gameBuilder: level,
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
        var gameBuilder: GameBuilding
        private(set) var startHandler: GameStartHandling
        private(set) var completionHandler: GameCompletionHandling
    }
    
    func play() {
        gameHandler?.state = .playing
    }
    
    func practice() {
        gameHandler?.state = .practicing
    }
    
    // TODO: Store score success array for useful statistics
    func finish(score: GameScore) {
        guard let level = gameHandler?.level,
              let index = index(for: level)  else { return }
        allLevels[index].scoreData.addScore(score.value)
        gameHandler?.state = .completed
        gameHandler?.level = allLevels[index]
        
        levelStore.update(level: allLevels[index])
    }
    
    func quit() {
        switch gameHandler?.state {
        case .playing, .practicing:
            gameHandler?.state = .quitted
        default:
            deselectLevel()
        }
    }
    
    private func deselectLevel() {
        gameHandler = nil
    }
        
}
