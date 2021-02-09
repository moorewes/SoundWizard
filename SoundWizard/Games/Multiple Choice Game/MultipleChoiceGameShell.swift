//
//  MultipleChoiceGameShell.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/8/21.
//

import SwiftUI

struct MultipleChoiceGameShell<Content: View>: View {
    var statusProvider: GameStatusProviding
    var choices: [ChoiceItem]
    @Binding var auditionState: AuditionState
    var content: () -> Content
    
    var body: some View {
        VStack {
            GameStatusBar(provider: statusProvider)
                .padding(.top, topSpace)
                .padding(.horizontal, statusBarHorizPadding)
            Spacer()
            
            content()
            Spacer()
            
            MultipleChoicePicker(choices: choices)
            
            Spacer()
            
            BeforeAfterPicker(state: $auditionState)
                .padding(.bottom, bottomSpace)
                .padding(.horizontal, statusBarHorizPadding)
        }
    }
    
    private let topSpace: CGFloat = 40
    private let bottomSpace: CGFloat = 50
    private let statusBarHorizPadding: CGFloat = 30
}

// MARK: Convenience Init
extension MultipleChoiceGameShell {
    init<Game: MultipleChoiceGame>(game: Game, auditionState: Binding<AuditionState>, content: @escaping () -> Content) {
        self.statusProvider = game
        self.choices = game.choiceItems
        self._auditionState = auditionState
        self.content = content
    }
}
