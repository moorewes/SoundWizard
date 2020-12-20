//
//  GameplayView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/17/20.
//

import SwiftUI

struct GameplayView: View {
    
    let game: GameHandling
    
    var body: some View {
        game.gameBuilder.buildGame(gameHandler: game)
    }
    
}

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
