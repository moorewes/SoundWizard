//
//  MultipleChoiceGameShell.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/8/21.
//

import SwiftUI

struct MultipleChoiceGameShell<Game: MultipleChoiceGame, Content: View>: View {
    @ObservedObject var viewModel: MultipleChoiceGameViewModel<Game>
    var content: () -> Content
    
    var body: some View {
        VStack {
            // Status
            GameStatusBar(provider: viewModel.statusProvider)
                .padding(.top, topSpace)
                .padding(.horizontal, statusBarHorizPadding)
            Spacer()
            
            // Specific Game Content
            content()
            Spacer()
            
            // Multiple Choices
            MultipleChoicePicker(choices: viewModel.choices,
                                 shouldReveal: viewModel.shouldRevealChoices) { selection in
                viewModel.choose(selection)
                
            }.padding()
            
            // Pre/Post Audition Switch
            BeforeAfterSwitch(state: $viewModel.auditionState)
                .padding(.bottom, bottomSpace)
                .padding(.horizontal, statusBarHorizPadding)
        }
    }
    
    private let topSpace: CGFloat = 40
    private let bottomSpace: CGFloat = 50
    private let statusBarHorizPadding: CGFloat = 30
}
