//
//  GameBuilding.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/24/20.
//

import SwiftUI

protocol GameBuilding {
    func buildGame(gameHandler handler: GameHandling) -> AnyView
}

extension EQDLevel: GameBuilding {
    func buildGame(gameHandler handler: GameHandling) -> AnyView {
        let game = EQDetectiveGame(level: self,
                                   practice: handler.state == .practicing,
                                   completionHandler: handler.completionHandler
        )
        return AnyView(EQDetectiveGameplayView(game: game))
    }
}
