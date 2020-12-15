//
//  LevelsViewModel.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/13/20.
//

import SwiftUI

class LevelsViewModel: ObservableObject {
    
    @Published var selectedLevel: EQDetectiveLevel?
    
    var showLevel: Bool {
        get {
            return selectedLevel != nil
        }
        set {
            selectedLevel = nil
        }
    }
    
    func starProgress(levels: [EQDetectiveLevel]) -> String {
        let total = levels.count * 3
        let earned = levels.reduce(0) { (count, level) in
            count + level.scoreData.starsEarned
        }
        return "\(earned)/\(total)"
    }
        
    func selectLevel(_ level: EQDetectiveLevel) {
        selectedLevel = level
    }
    
    func dismissLevel() {
        selectedLevel = nil
    }
    
    var game: Game
    
    init(game: Game) {
        self.game = game
    }
    
    
}
