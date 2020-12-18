//
//  GameplayView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/17/20.
//

import SwiftUI

struct GameplayView: View {
    
    let level: Level
    @Binding var viewState: GameViewState
    
    var body: some View {
        gameplayView()
    }
    
    @ViewBuilder
    private func gameplayView() -> some View {
        switch level {
        case .eqDetective(let level):
            EQDetectiveGameplayView(level: level, gameViewState: $viewState, practicing: false)
        }
    }
    
}
