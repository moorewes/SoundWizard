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
