//
//  PostGameView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/3/20.
//

import SwiftUI

struct PostGameView: View {
    
    var level: Level
    @Binding var gameViewState: GameViewState
    @State var animated = false
            
    var body: some View {
        
        VStack {
                        
            Text("Your Score")
                .font(.mono(.headline))
                .foregroundColor(.lightGray)
                .padding(.top, 60)
        
            Text((level.scoreData.scores.last ?? 0).scoreString(digits: 4))
                .font(.mono(.largeTitle, sizeModifier: 16))
            
            Text("Top Score")
                .font(.mono(.headline))
                .foregroundColor(.lightGray)
                .padding(.top, 60)
            
            MovingCounter(number: animated ? level.scoreData.topScore : previousTopScore,
                                 font: .mono(.largeTitle, sizeModifier: 16),
                                 duration: 1.5)
            
            stars
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
            
            Spacer()
            
            PlayButton(gameViewState: $gameViewState)
                .padding(.bottom, 40)
            
        }
        .onAppear {
            animated = justEarnedTopScore
        }
        
    }
    
    private var stars: some View {
        HStack(spacing: 0) {
            ForEach(0..<3) { i in
                star(number: i + 1)
            }
        }
    }
    
    private func star(number: Int) -> some View {
        let justEarnedIndex = level.scoreData.newStars.firstIndex(of: number)
        let isEarned = level.scoreData.starsEarned >= number
        var animationDelay = 1.0
        if let index = justEarnedIndex {
            animationDelay += Double(index) * timeBetweenStarAnimations
        }
        let shouldAnimate = justEarnedIndex != nil
        return VStack {
            Star(filled: isEarned, number: number, animated: shouldAnimate, animationDelay: animationDelay)
                .font(.system(size: 42))
                .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                        
            Text("\(level.scoreData.starScores[number - 1])")
                .foregroundColor(.teal)
                .font(.mono(.headline))
        }
    }
    
    private var previousTopScore: Int {
        var scores = level.scoreData.scores
        guard !scores.isEmpty else { return 0 }
        
        scores.removeLast()
        return scores.sorted().last ?? 0
    }
    
    private var justEarnedTopScore: Bool {
        level.scoreData.topScore > previousTopScore
    }
    
    private let timeBetweenStarAnimations = 0.3
    private let starAnimationDuration = 0.7
    
}

//struct PostGameView_Previews: PreviewProvider {
//    static let level = TestLevel()
//    static var previews: some View {
//        PostGameView(level: level, gameViewState: .constant(.gameCompleted))
//            .preferredColorScheme(.dark)
//            .onAppear {
//                level.scores = []
//            }
//    }
//}
