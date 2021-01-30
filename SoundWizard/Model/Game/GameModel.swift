//
//  GameModel.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/25/20.
//

import SwiftUI

protocol GameModelType {}

protocol InstructionViewType {}

protocol StandardGame: GameModel, StageBased, ScoreBased, ScoreMultipliable, LivesBased {}

protocol GameModel: GameStatusPublisher {
    func fireFeedback()
}

extension GameModel where Self: TurnBased {
    func fireFeedback() {
        guard let successLevel = currentTurn?.score?.successLevel else {
            fatalError("Couldn't find score to fire feedback)")
        }
        
        Conductor.master.fireScoreFeedback(successLevel: successLevel)
        HapticGenerator.main.fire(successLevel: successLevel)
    }
}
