//
//  Game.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/2/20.
//

import Foundation
import UIKit

enum Game: Int, CaseIterable, Identifiable {
    
    static let starCount = 3
    
    case eqDetective = 0

    var id: Int { return self.rawValue }

    var name: String {
        switch self {
        case .eqDetective: return "EQ Detective"
        }
    }

    var levels: [Level] {
        switch self {
        case .eqDetective:
            return EQDetectiveLevel.levels
        }
    }
    
    var starProgress: (total: Int, earned: Int) {
        let total = self.levels.count * Game.starCount
        let earned = self.levels.reduce(0) { (tally, level) in
            tally + level.progress.starsEarned
        }
        
        return (total, earned)
    }
    
}


