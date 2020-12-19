//
//  GameplayView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/17/20.
//

import SwiftUI

struct GameplayView: View {
    
    let level: LevelVariant
    var completion: (Score?) -> Void
    //@Binding var viewState: GameViewState
    
    var body: some View {
        gameplayView()
    }
    
//    @ViewBuilder
//    private func gameplayView() -> some View {
//        switch level {
//        case .eqDetective(let level):
//            let game = EQDetectiveGame(level: level, onCompletion: )
//            EQDetectiveGameplayView(game: game)
//        }
//    }
    
    @ViewBuilder
    private func gameplayView() -> some View {
        if let level = level as? EQDLevel {
            let game = EQDetectiveGame(level: level, onCompletion: completion)
            EQDetectiveGameplayView(game: game)
        }
    }
    
}
