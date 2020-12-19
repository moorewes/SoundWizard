//
//  GameplayView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/17/20.
//

import SwiftUI

struct GameplayView: View {
    
    let level: Level
    var completionHandler: GameCompletionHandling
    
    var body: some View {
        gameplayView()
    }
    
    @ViewBuilder
    private func gameplayView() -> some View {
        if let level = level as? EQDLevel {
            let game = EQDetectiveGame(level: level, completionHandler: completionHandler)
            EQDetectiveGameplayView(game: game)
        }
    }
    
}
