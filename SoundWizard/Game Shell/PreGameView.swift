//
//  EQDetectivePreGameView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/17/20.
//

import SwiftUI

struct PreGameView: View {
    
    var level: Level
    @Binding var gameViewState: GameViewState
    //@ObservedObject var manager: GameShellManager
        
    var shouldShowLastScore: Bool { gameViewState == .gameCompleted }
                    
    var body: some View {
        ZStack {
            Color.darkBackground
                .ignoresSafeArea()
            
            VStack {
                                
                // Top Score
                
                Text("Top Score")
                    .font(.mono(.headline))
                    .foregroundColor(.lightGray)
                    .padding()
                
                topScore
                    .padding(.bottom, 50)
                
                // Stars
                
                stars
                
                Spacer()
                
                // Instruction View
                
                if !shouldShowLastScore {
                    instructionView()
                        .foregroundColor(.lightGray)
                        .padding(.horizontal, 50)
                }
                
                Spacer()
                
                PlayButton(gameViewState: $gameViewState)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 40, trailing: 10))
                
            }
        }
        
    }
    
    private var topScore: some View {
        MovingCounter(number: level.topScore,
                      font: .mono(.largeTitle, sizeModifier: 16),
                      duration: 1.5)
    }
    
    private var stars: some View {
        HStack(spacing: 0) {
            Spacer()
            ForEach(0..<3) { i in
                if i > 0 {
                    Spacer()
                }
                star(number: i + 1)
            }
            Spacer()
        }
    }
    
    private func star(number: Int) -> some View {
        let isEarned = level.starsEarned >= number
        return VStack {
            Star(filled: isEarned, number: number, animated: false)
                .font(.system(size: 42))
                .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
                        
            Text("\(level.starScores[number - 1])")
                .foregroundColor(.teal)
                .font(.mono(.headline))
        }
    }
    
    @ViewBuilder
    private func instructionView() -> some View {
        if level is EQDetectiveLevel {
            EQDetectiveInstructionView(level: level)
        }
    }
    
    private let starImageName = "star.fill"
    private let timeBetweenStarAnimations = 0.4
    private let starAnimationDuration = 0.7
    
}

struct EQDetectivePreGameView_Previews: PreviewProvider {
    static let manager = GameShellManager(level: TestLevel())
    static var previews: some View {
        PreGameView(level: TestLevel(), gameViewState: .constant(.preGame))
    }
}
