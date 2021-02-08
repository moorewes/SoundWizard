//
//  EQDetectivePreGameView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/17/20.
//

import SwiftUI

struct PreGameView: View {
    let level: Level
    let gameHandler: GameStartHandling
                                
    var body: some View {
        VStack {
            Text("Top Score")
                .font(.mono(.headline))
                .foregroundColor(.lightGray)
                .padding()
            
            topScore
                //.padding(.bottom)
                        
            stars
                .padding()
                                    
            instructionView()
                .foregroundColor(.lightGray)
                .padding(.horizontal, 50)
                .padding(.vertical, 30)
                
            
            PlayButton(title: "PLAY") {
                gameHandler.play()
            }
            .padding(.vertical, 20)
            
            PlayButton(title: "PRACTICE") {
                gameHandler.practice()
            }
            .padding(.bottom, 20)
        }
    }
    
    private var topScore: some View {
        MovingCounter(number: level.scoreData.topScore,
                      font: .mono(.largeTitle, sizeModifier: 0),
                      duration: 1.5)
    }
    
    private var stars: some View {
        HStack(spacing: 0) {
            Spacer()
            ForEach(0..<3) { i in
                star(number: i + 1)
                    .padding(.horizontal)
            }
            Spacer()
        }
    }
    
    private func star(number: Int) -> some View {
        let isEarned = level.scoreData.starsEarned >= number
        return VStack {
            AnimatedStar(filled: isEarned, number: number, animated: false)
                .font(.system(size: 30))
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                        
            Text("\(level.scoreData.starScores[number - 1])")
                .foregroundColor(.teal)
                .font(.mono(.headline))
        }
    }
    
    @ViewBuilder
    private func instructionView() -> some View {
        if let level = level as? EQDLevel {
            EQDetectiveInstructionView(level: level)
        } else if let level = level as? EQMatchLevel {
            EQMatchInstructionView(level: level)
        }
    }
    
    private let starImageName = "star.fill"
    private let timeBetweenStarAnimations = 0.4
    private let starAnimationDuration = 0.7
    
}

struct PreGameView_Previews: PreviewProvider {
    static var previews: some View {
        PreGameView(level: TestData.eqMatchLevel, gameHandler: TestData.GameStartHandler())
    }
}
