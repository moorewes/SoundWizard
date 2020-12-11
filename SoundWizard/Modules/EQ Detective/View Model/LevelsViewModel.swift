//
//  LevelsViewModel.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/13/20.
//

import SwiftUI

class LevelsViewModel: ObservableObject {
    
    @Published var levels: [EQDetectiveLevel]
    @Published var selectedLevel: EQDetectiveLevel?
    
    
    
    var showLevel: Bool {
        get {
            return selectedLevel != nil
        }
        set {
            selectedLevel = nil
        }
    }
    
    func levels(focus: BandFocus, difficulty: LevelDifficulty, gainType: Int) -> [EQDetectiveLevel] {
        levels.filter {
            $0.bandFocus == focus &&
            $0.difficulty == difficulty &&
            (gainType == 1) == ($0.filterGainDB > 0)
        }
    }
    
    func starProgress(levels: [EQDetectiveLevel]) -> String {
        let total = levels.count * 3
        let earned = levels.reduce(0) { (count, level) in
            count + level.starsEarned
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
        levels = game.levels as! [EQDetectiveLevel]
    }
    
    
}
