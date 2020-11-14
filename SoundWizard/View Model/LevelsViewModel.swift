//
//  LevelsViewModel.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/13/20.
//

import SwiftUI

class LevelsViewModel: ObservableObject {
    
    @Published var levels: [Level]
    
    var game: Game = Game.eqDetective
    
    init() {
        levels = game.levels
    }
    
    
}
