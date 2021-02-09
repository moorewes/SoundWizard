//
//  MultipleChoicePicker.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/8/21.
//

import SwiftUI

struct MultipleChoicePicker: View {
    var choices: [ChoiceItem]
    var shouldDisplayResults = false
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(choices) { choice in
                ChoiceButton(choice: choice)
            }
        }
        .padding(.horizontal)
    }
    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: columnsCount)
    }
    
    private func itemWidth(viewWidth: CGFloat) -> CGFloat {
        viewWidth / CGFloat(columnsCount) - CGFloat(columnsCount) * choicesHorizSpacing
    }
    
    private let choicesHorizSpacing: CGFloat = 20
    private let columnsCount: Int = 2
}

// MARK: Choice Button
extension MultipleChoicePicker {
    struct ChoiceButton: View {
        var choice: ChoiceItem
        @State var animationColor: Color?
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundColor(animationColor ?? defaultBackgroundColor)
                    .animation(.easeIn(duration: 0.2))
                
                Button(action: choice.action, label: {
                    Text(choice.title)
                })
                .foregroundColor(.black)
                .padding(.vertical)
            }
            .padding()
            .onAppear {
                switch choice.status {
                case .revealed(let isCorrect):
                    animationColor = isCorrect ? .green : .red
                case .standby:
                    break
                }
            }
        }
        
        private let defaultBackgroundColor = Color.teal
        private let cornerRadius: CGFloat = 20
    }
}

struct MultipleChoiceGameplayView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleChoicePicker(choices: TestData.fourMCItemsHidden)
            .background(Gradient.background)
            .font(.std(.subheadline))
    }
}

