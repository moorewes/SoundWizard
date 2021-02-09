//
//  StatusBar.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/25/20.
//

import SwiftUI

struct GameStatusBar: View {
    let score: Int
    let scoreMultiplier: Double?
    let maxLives: Int
    let remainingLives: Int
    
    var body: some View {
        HStack() {
            ScoreView(score: score)
            ScoreMultiplierView(multiplier: scoreMultiplier)
            
            Spacer()
            
            LivesView(maxLives: maxLives, remainingLives: remainingLives)
        }
    }
}

// MARK: Init with GameStatusProvider
extension GameStatusBar {
    init(provider: GameStatusProviding) {
        self.score = provider.score
        self.scoreMultiplier = provider.scoreMultiplierValue
        self.maxLives = provider.maxLives
        self.remainingLives = provider.remainingLives
    }
}

// MARK: Score View
extension GameStatusBar {
    struct ScoreView: View {
        let score: Int
        
        var body: some View {
            VStack {
                Text("SCORE")
                    .font(.mono(.callout))
                    .foregroundColor(.init(white: 1, opacity: 0.5))
                Text("\(score)")
                    .modifier(MovingCounterModifier(number: score,
                                                    font: .mono(.title3)))
                    .animation(.linear(duration: 0.5))
            }
        }
    }
}

// MARK: Score Multiplier View
extension GameStatusBar {
    struct ScoreMultiplierView: View {
        let multiplier: Double?
        
        var body: some View {
            Text(text)
                .font(.mono(.headline))
                .foregroundColor(.teal)
        }
        
        private var text: String {
            if let multiplier = self.multiplier {
                return " x\(Int(multiplier))"
            } else {
                return " "
            }
        }
    }
}

// MARK: Lives View
extension GameStatusBar {
    struct LivesView: View {
        let maxLives: Int
        let remainingLives: Int
        
        var body: some View {
            VStack {
                Text("LIVES")
                    .font(.mono(.callout))
                    .foregroundColor(.init(white: 1, opacity: 0.5))
                    .offset(CGSize(width: 0, height: -9))
                
                HStack() {
                    ForEach(1..<maxLives) { i in
                        let visible = remainingLives >= maxLives - i
                        HeartView(visible: visible)
                    }
                }
            }
        }
    }
}

// MARK: Heart View
extension GameStatusBar.LivesView {
    struct HeartView: View {
        let visible: Bool
        var body: some View {
            Image(systemName: imageName)
                .foregroundColor(.teal)
                .opacity(visible ? 1 : 0)
                .scaleEffect(visible ? 1 : 0.01)
                .animation(visible ?
                           .easeIn(duration: 0.5) :
                           .easeIn(duration: 1.5))
        }
        
        private let imageName = "heart.fill"
    }
}
