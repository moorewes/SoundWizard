//
//  Game.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/2/20.
//

import Foundation
import UIKit

enum Game: Int, CaseIterable {
    
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
    
    func viewModel(level: Level) -> EQDetectiveViewModel {
        switch level.game {
        case .eqDetective:
            return EQDetectiveViewModel(level: level)
        }
    }
    
}


