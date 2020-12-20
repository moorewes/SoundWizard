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
    case playing
    case practicing
    case quitted
    case completed

    var isInGame: Bool {
        self == .playing || self == .practicing
    }
    
}
