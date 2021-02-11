//
//  MultipleChoicePicker.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/8/21.
//

import SwiftUI

// MARK: Picker
struct MultipleChoicePicker<Choice: MultipleChoiceGameChoice>: View {
    var choices: [Choice]
    var shouldReveal: Bool
    let selectChoice: (Choice) -> Void
    
    var body: some View {
        Grid(choices: choices) { choice in
            ChoiceButton(choice: choice, isRevealed: shouldReveal, action: selectChoice)
                .foregroundColor(buttonColor(for: choice))
        }
    }
    
    private func buttonColor(for choice: Choice) -> Color {
        shouldReveal ? choice.isCorrect ? successColor : failureColor : unrevealedColor
    }
    
    private let unrevealedColor = Color.teal
    private let successColor = Color.green
    private let failureColor = Color.red
}

// MARK: Grid
extension MultipleChoicePicker {
    struct Grid<Content: View>: View {
        let choices: [Choice]
        let content: (Choice) -> Content
        
        var body: some View {
            LazyVGrid(columns: columns) {
                ForEach(choices, content: content)
            }
            .padding(.horizontal)
        }
        
        private var columns: [GridItem] {
            Array(repeating: GridItem(.flexible()), count: columnsCount)
        }
        
        private let columnsCount: Int = 2
    }
}

// MARK: Choice Button
extension MultipleChoicePicker {
    struct ChoiceButton: View {
        var choice: Choice
        var isRevealed: Bool
        let action: (Choice) -> Void
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .animation(.easeOut(duration: 0.1))
                
                Button(action: {
                    action(choice)
                }, label: {
                    Text(choice.title)
                })
                .foregroundColor(.black)
                .padding(.vertical)
            }
            .padding()
        }
        
        private let cornerRadius: CGFloat = 20
    }
}
