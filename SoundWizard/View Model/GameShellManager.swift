//
//  GameShellManager.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/24/20.
//

import SwiftUI

class GameShellManager: ObservableObject {
    
    var level: Level
    
    @Published var gameViewState: GameViewState = .preGame
        
    init(level: Level) {
        self.level = level
    }
    
    func quitGame() {
        gameViewState = .gameQuitted
    }
 
}
