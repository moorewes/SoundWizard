//
//  GainBrainGameplayView.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/8/21.
//

import SwiftUI

struct GainBrainGameplayView: View {
    @ObservedObject var game: GainBrainGame
    
    var body: some View {
        MultipleChoiceGameShell(game: game, auditionState: $game.auditionState) {
            Text(game.instructionText)
        }
    }
}



struct GainBrainGameplayView_Previews: PreviewProvider {
    static let game = GainBrainGame()
    
    static var previews: some View {
        GainBrainGameplayView(game: game)
            .accentColor(.teal)
            .font(.std(.subheadline))
            .background(Gradient.background.ignoresSafeArea())
    }
}
