//
//  GameShellManager.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/24/20.
//

import SwiftUI

class GameShellManager: ObservableObject {
    
    var level: Level
    
    @Published var starsJustEarned = [Int]()
    
    @Published var gameViewState: GameViewState = .preGame {
        didSet {
            if gameViewState == .inGame {
                starsAtGameStart = level.progress.starsEarned
            } else if gameViewState == .gameCompleted {
                starsJustEarned = Array(1...3).filter { $0 > starsAtGameStart && $0 <= level.progress.starsEarned }
            }
        }
    }
    
    private var starsAtGameStart = 0
            
    init(level: Level) {
        self.level = level
    }
    
    func quitGame() {
        gameViewState = .gameQuitted
    }
    
    func showInfoView() {
        
    }
    
    func showSettingsView() {
        
    }
    
}
