//
//  StateController.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/15/20.
//

import SwiftUI

class StateController: ObservableObject {
    
    private let dataManager = CoreDataManager.shared
    
    private var allLevels = [Level]()
    
    @Published var level: Level?
    @Published var dailyLevels: [Level]
    @Published var gameState = GameViewState.preGame
    
    var presentingLevel: Bool {
        get {
            return level != nil
        }
        set {
            level = nil
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
    }
    
    func levels(for game: Game) -> [Level] {
        allLevels.filter { $0.game == game }
    }
    
    func levels<T: LevelVariant>() -> [T] {
        return allLevels.compactMap { $0.levelVariant as? T }
    }

}
