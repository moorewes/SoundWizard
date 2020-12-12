//
//  GameShellManager.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/24/20.
//

import SwiftUI

class GameShellManager: ObservableObject {
    
    var level: Level
    
    @Published var gameViewState: GameViewState = .preGame {
        didSet {
            print(gameViewState)
        }
    }
    
    var lastRoundScore: Int {
        level.scores.last ?? 0
    }
    
    var topScore: Int {
        return level.topScore
    }
    
    var previousTopScore: Int {
        var scores = level.scores
        let last = scores.popLast()
        return scores.sorted().last ?? last ?? 0
    }
    
    var justEarnedTopScore: Bool {
        topScore > previousTopScore
    }
            
    init(level: Level) {
        print("game shell manager init")
        self.level = level
        print(Unmanaged.passUnretained(self).toOpaque())
    }
    
    deinit {
        print("game shell manager deinit")
        print(Unmanaged.passUnretained(self).toOpaque())
    }
    
    func quitGame() {
        gameViewState = .gameQuitted
    }
    
    func showInfoView() {
        
    }
    
    func showSettingsView() {
        
    }
    
}
