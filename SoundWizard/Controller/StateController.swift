//
//  StateController.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/15/20.
//

import SwiftUI

// TODO: Organize once architecture determined
class StateController: ObservableObject {
    private let levelStore: LevelFetching & LevelStoring
    
    private var allLevels = [Level]()
    
    var dailyLevels: [Level] {
        let eqmLevels = levels(for: .eqMatch)
        var result = [Level]()
        while result.count < 10 {
            let int = Int.random(in: 0..<eqmLevels.count)
            result.append(eqmLevels[int])
        }
        return result
    }
    
    var levelBrowsingStore: LevelBrowsingStore?
    
    @Published var levelPacks = [LevelPack]()
    
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
    
    var gameData: [Game.Data] {
        Game.allCases.map { game in
            let stars = levels(for: game).starProgress
            return Game.Data(game: game, stars: stars)
        }
    }
    
    init(levelStore: LevelFetching & LevelStoring) {
        self.levelStore = levelStore
        allLevels = Game.allCases.flatMap {
            levelStore.fetchLevels(for: $0)
        }
        makeTestPacks()
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
    
    private func makeTestPacks() {
        levelPacks.append(LevelPack(name: "Starter Pack", id: "pack1", levels: Array(allLevels.prefix(5))))
        levelPacks.append(LevelPack(name: "Frequency Freak", id: "pack2", levels: Array(allLevels.suffix(5))))
    }
}

// MARK: - Game Handling

extension StateController: GameTransitionHandling {
    struct GameHandler: GameHandling {
        var level: Level
        private(set) var state: GameViewState
        var gameBuilder: GameBuilding
        private(set) var startHandler: GameStartHandling
        private(set) var completionHandler: GameCompletionHandling
        
        mutating func setState(_ state: GameViewState) {
            withAnimation {
                self.state = state
            }
        }
    }
    
    func play() {
        gameHandler?.setState(.playing)
    }
    
    func practice() {
        gameHandler?.setState(.practicing)
    }
    
    // TODO: Store score success array for useful statistics
    func finish(score: GameScore) {
        guard let level = gameHandler?.level,
              let index = index(for: level)  else { return }
        allLevels[index].scoreData.addScore(score.value)
        gameHandler?.setState(.completed)
        gameHandler?.level = allLevels[index]
        
        levelStore.update(level: allLevels[index])
    }
    
    func quit() {
        switch gameHandler?.state {
        case .playing, .practicing:
            gameHandler?.setState(.quitted)
        default:
            deselectLevel()
        }
    }
    
    private func deselectLevel() {
        gameHandler = nil
        Conductor.master.stop()
    }
        
}
