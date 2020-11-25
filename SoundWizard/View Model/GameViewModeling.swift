//
//  GameViewModeling.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/17/20.
//

import SwiftUI

enum GameViewState: Int {
    case preGame = 0, inGame, gameCompleted, gameQuitted
}

protocol GameViewModeling: ObservableObject {
    
    var level: Level { get set }
    var gameViewState: GameViewState { get set }
    
    func cancelGameplay()
    func fireFeedback(successLevel: ScoreSuccessLevel)
        
}

extension GameViewModeling {
    
    func fireFeedback(successLevel: ScoreSuccessLevel) {
        SoundFXManager.main.playTurnResultFX(successLevel: successLevel)
        HapticGenerator.main.fire(successLevel: successLevel)
    }
    
}
