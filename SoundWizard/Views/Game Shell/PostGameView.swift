//
//  PostGameView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/3/20.
//

import SwiftUI

// TODO: Cleanup
struct PostGameView: View {
    let scoreData: ScoreData
    let gameHandler: GameStartHandling
    
    @State private var animated = false
            
    var body: some View {
        VStack {
            Text("Your Score")
                .font(.mono(.headline))
                .foregroundColor(.lightGray)
                .padding(.top, 60)
        
            Text((scoreData.scores.last ?? 0)
                .scoreString(digits: 4))
                .font(.mono(.largeTitle, sizeModifier: 16))
                .foregroundColor(.teal)
            
            Text("Top Score")
                .font(.mono(.headline))
                .foregroundColor(.lightGray)
                .padding(.top, 60)

            MovingCounter(number: animated ? scoreData.topScore : previousTopScore,
                                 font: .mono(.largeTitle, sizeModifier: 16),
                                 duration: 1.5)
            
            stars
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
            
            Spacer()
            
            PlayButton(title: "PLAY") {
                gameHandler.play()
            }
            .padding(.bottom, 10)
            
            PlayButton(title: "PRACTICE") {
                gameHandler.practice()
            }
                .padding(.bottom, 40)
            
        }
        .onAppear {
            animated = justEarnedTopScore
        }
        
    }
    
    private var stars: some View {
        HStack(spacing: 0) {
            ForEach(1..<4) { i in
                star(number: i)
            }
        }
    }
    
    private func star(number: Int) -> some View {
        let animationIndex = scoreData.newStars.firstIndex(of: number)
        let isEarned = scoreData.starsEarned >= number
        let animationDelay = 1.5 + 1.0 * Double(animationIndex ?? 0) * timeBetweenStarAnimations
        let shouldAnimate = animationIndex != nil
        
        return VStack {
            Star(filled: isEarned, number: number, animated: shouldAnimate, animationDelay: animationDelay)
                .font(.system(size: 42))
                .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                        
            Text("\(scoreData.starScores[number - 1])")
                .foregroundColor(.teal)
                .font(.mono(.headline))
        }
    }
    
    private var justEarnedTopScore: Bool {
        scoreData.previousTopScore < scoreData.topScore
    }
    
    private var previousTopScore: Int {
        var previousScoreData = scoreData
        guard previousScoreData.scores.count > 1 else { return 0 }
        
        previousScoreData.scores.removeLast()
        
        return previousScoreData.scores.sorted().last ?? 0
    }
    
    private let timeBetweenStarAnimations = 0.4
    private let starAnimationDuration = 0.7
}
