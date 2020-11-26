//
//  GameModel.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/25/20.
//

import SwiftUI

protocol GameModel: ObservableObject {
    
    associatedtype TurnType: Turn
    associatedtype ConductorType: GameConductor
    
    var conductor: ConductorType { get set }
    
    var currentTurn: TurnType? { get }
    var score: Int { get }
    var completion: Float { get }
    var muted: Bool { get }
    
    func toggleMute()
    
    func fireFeedback()
    
}

extension GameModel {
    
    func fireFeedback() {
        guard let successLevel = currentTurn?.score?.successLevel else {
            fatalError("Couldn't find score to fire feedback)")
        }
        
        conductor.fireScoreFeedback(successLevel: successLevel)
        HapticGenerator.main.fire(successLevel: successLevel)
    }
    
}
