//
//  GainBrainGameplayView.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/8/21.
//

import SwiftUI

struct GainBrainGameplayView: View {
    @ObservedObject var viewModel: MultipleChoiceGameViewModel<GainBrainGame>
    
    init(game: GainBrainGame) {
        viewModel = MultipleChoiceGameViewModel(game: game)
    }
    
    var body: some View {
        MultipleChoiceGameShell(viewModel: viewModel) {
            Content(title: viewModel.game.instructionText)
        }
    }
}

extension GainBrainGameplayView {
    struct Content: View {
        let title: String
        var body: some View {
            Text(title)
        }
    }
}

struct GainBrainGameplayView_Previews: PreviewProvider {
    static let game = GainBrainGame(audio: TestData.audioMetadataArray)
    
    static var previews: some View {
        GainBrainGameplayView(game: game)
            .accentColor(.teal)
            .font(.std(.subheadline))
            .background(Gradient.background.ignoresSafeArea())
    }
}
