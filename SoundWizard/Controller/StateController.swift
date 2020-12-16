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
    @Published var gameState: GameViewState?
    
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
            GameItem(name: game.name,
                     stars: starProgress(for: levels(for: game)),
                     levels: levels(for: game))
        }
    }
    
    init() {
        allLevels = dataManager.allLevels()
        dailyLevels = allLevels.filter { $0.number < 5 }
    }
    
    func levels(for game: Game) -> [Level] {
        allLevels.filter { $0.game == game }
    }
    
    func starProgress(for levels: [Level]) -> StarProgress {
        let earned = levels.reduce(0) { $0 + $1.scoreData.starsEarned }
        let total = levels.count * StarProgress.levelMax
        return StarProgress(total: total, earned: earned)
    }

}



