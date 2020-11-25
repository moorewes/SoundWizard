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
    
    var showLevel: Bool {
        get {
            return selectedLevel != nil
        }
        set {
            selectedLevel = nil
        }
    }
        
    func selectLevel(_ level: Level) {
        selectedLevel = level
    }
    
    func dismissLevel() {
        selectedLevel = nil
    }
    
    var game: Game
    
    init(game: Game) {
        self.game = game
        levels = game.levels
    }
    
    
}
