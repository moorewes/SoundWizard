//
//  PostGameView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/3/20.
//

import SwiftUI

struct PlayButton: View {
    @Binding var gameViewState: GameViewState
    
    var body: some View {
        Button(action: {
            gameViewState = .inGame
        }, label: {
            ZStack {
                Rectangle()
                    .foregroundColor(.teal)
                    .cornerRadius(10)
                    .frame(width: 200, height: 50, alignment: .center)
                Text("PLAY")
                    .font(.monoBold(20))
                    .foregroundColor(.darkBackground)
            }
            
        })
    }
}

struct PostGameView: View {
    
    @ObservedObject var manager: GameShellManager
    @State var animated = false
    
    var prevTopScore: Int
    var newTopScore: Int
    
    var willAnimate: Bool { newTopScore > prevTopScore }
    var score: Int { manager.level.progress.scores.last ?? 0 }
    
    var body: some View {
        
        VStack {
                        
            Text("Your Score")
                .font(.monoMedium(20))
                .foregroundColor(.lightGray)
                .padding(.top, 60)
        
            Text(score.scoreString(digits: 4))
                .font(.monoBold(48))
                .transition(.opacity).animation(Animation.easeIn(duration: 4))

            
            Text("Top Score")
                .font(.monoMedium(20))
                .foregroundColor(.lightGray)
                .padding(.top, 60)
        
            MovingCounter(number: animated ? newTopScore : prevTopScore,
                                 font: .monoBold(48),
                                 duration: 1.5)
            
            stars
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
            
            Spacer()
            
            PlayButton(gameViewState: $manager.gameViewState)
                .padding(.bottom, 40)
            
            
        }
        .onAppear {
            if willAnimate {
                animated = true
            }
            
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
        let earned = manager.level.progress.starsEarned >= number
        let justEarnedIndex = manager.starsJustEarned.firstIndex(of: number)
        var animationDelay = 1.0
        if let index = justEarnedIndex {
            animationDelay += Double(index) * timeBetweenStarAnimations
            print("will animate star \(number) after \(animationDelay) seconds")
        }
        let shouldAnimate = justEarnedIndex != nil
        return VStack {
            Star(filled: earned, number: number, animated: shouldAnimate, animationDelay: animationDelay)
                .font(.system(size: 42))
                .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                        
            Text("\(manager.level.starScores[number - 1])")
                .foregroundColor(.teal)
                .font(.monoBold(20))
        }
    }
    
    private let timeBetweenStarAnimations = 0.2
    private let starAnimationDuration = 0.7
    
}

struct PostGameView_Previews: PreviewProvider {
    static var previews: some View {
        PostGameView(manager: GameShellManager(level: EQDetectiveLevel.level(2)!),
                     prevTopScore: 100, newTopScore: 200)
            .preferredColorScheme(.dark)
    }
}
