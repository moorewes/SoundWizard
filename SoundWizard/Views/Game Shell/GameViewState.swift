//
//  GameViewState.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/25/20.
//

import Foundation

enum GameViewState {
    case none
    case preGame(level: LevelVariant)
    case inGame(level: LevelVariant, practicing: Bool)
    case gameQuitted
    case gameCompleted(score: Score)
    
    var practicing: Bool {
        switch self {
        case .inGame(_, let practicing):
            return practicing
        default: return false
        }
    }
}
