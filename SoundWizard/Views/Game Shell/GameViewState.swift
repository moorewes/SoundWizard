//
//  GameViewState.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/25/20.
//

import Foundation

enum GameViewState {
    case none
    case preGame
    case inGame(practicing: Bool)
    case gameQuitted
    case gameCompleted
    
    var practicing: Bool {
        switch self {
        case .inGame(let practicing):
            return practicing
        default: return false
        }
    }
}
