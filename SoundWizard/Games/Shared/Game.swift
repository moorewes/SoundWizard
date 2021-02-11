//
//  Game.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/2/20.
//

import Foundation
import SwiftUI

enum Game: Int, CaseIterable, Identifiable {        
    case eqDetective = 0, eqMatch, gainBrain

    var id: Int { return self.rawValue }

    var name: String {
        switch self {
        case .eqDetective: return "EQ Detective"
        case .eqMatch: return "EQ Match"
        case .gainBrain: return "Gain Brain"
        }
    }
    
    var shortName: String {
        switch self {
        case .eqDetective: return "EQ Detect"
        case .eqMatch: return name
        case .gainBrain: return name
        }
    }
}

extension Game {
    struct Data {
        let game: Game
        let title: String
        let shortTitle: String
        let stars: StarProgress
        
        init(game: Game, stars: StarProgress) {
            self.game = game
            self.title = game.name
            self.shortTitle = game.shortName
            self.stars = stars
        }
    }
}

extension Game.Data: Identifiable {
    var id: String { title }
}
