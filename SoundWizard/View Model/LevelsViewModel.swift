//
//  LevelsViewModel.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/13/20.
//

import SwiftUI

class LevelsViewModel: ObservableObject {
    
    @Published var levels: [Level]
    @Published var selectedLevel: Level?
    @Published var showLevel = false
    
    func didSelectLevel(_ level: Level) {
        selectedLevel = level
        showLevel = true
    }
    
    var game: Game
    
    init(game: Game) {
        self.game = game
        levels = game.levels
    }
    
    
}
