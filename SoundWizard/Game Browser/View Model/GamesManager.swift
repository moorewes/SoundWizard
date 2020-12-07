//
//  GamesManager.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/13/20.
//

import SwiftUI

class GamesManager: ObservableObject {
    
    @Published var games: [Game] = Game.allCases
    
    func starProgress(game: Game) -> String {
        let progress = game.starProgress
        return "\(progress.earned)/\(progress.total)"
    }
    
}
