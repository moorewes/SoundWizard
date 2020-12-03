//
//  EQDetectivePreGameView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/17/20.
//

import SwiftUI

struct PreGameView: View {
        
    @ObservedObject var manager: GameShellManager
        
    var starsEarned: Int { manager.level.progress.starsEarned }
            
    var body: some View {
        ZStack {
            Color.darkBackground
                .ignoresSafeArea()
            
            VStack {
                
                // Top Score
                
                Text("Top Score")
                    .font(.monoMedium(20))
                    .foregroundColor(.lightGray)
                    .padding()
                
                Text("\(manager.level.progress.topScore ?? 0)")
                    .font(.monoBold(48))
                    .foregroundColor(.teal)
                    .padding()
                
                // Stars
                
                stars
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                
                // Instruction View
                                
                instructionView
                    .foregroundColor(.teal)
                    .background(Color.darkBackground)
                    .cornerRadius(20)
                    .padding(EdgeInsets(top: 20, leading: 50, bottom: 50, trailing: 50))
                                
                // Start Button
                
                Button(action: {
                    manager.gameViewState = .inGame
                }, label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.teal)
                            .cornerRadius(10)
                            .frame(width: 200, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Text("PLAY")
                            .font(.monoBold(20))
                            .foregroundColor(.darkBackground)
                    }
                    
                })
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 40, trailing: 10))
                
            }
        }
        
    }
    
    private var stars: some View {
        HStack(spacing: 0) {
            Spacer()
            ForEach(0..<3) { i in
                if i > 0 {
                    Spacer()
                }
                star(number: i + 1)
                    //.padding()
            }
            Spacer()
        }
    }
    
    private func star(number: Int) -> some View {
        let earned = starsEarned >= number
        let justEarnedIndex = manager.starsJustEarned.firstIndex(of: number)
        var animationDelay = 0.0
        if let index = justEarnedIndex {
            animationDelay = Double(index) * timeBetweenStarAnimations
            print("will animate star \(number) after \(animationDelay) seconds")
        }
        let shouldAnimate = justEarnedIndex != nil
        return VStack {
            Star(filled: earned, animated: shouldAnimate, animationDelay: animationDelay)
                .font(.system(size: 42))
                .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
                        
            Text("\(manager.level.starScores[number - 1])")
                .foregroundColor(.teal)
                .font(.monoBold(20))
        }
    }
    
    private var instructionView: some View {
        switch manager.level.game {
        case .eqDetective:
            return EQDetectiveInstructionView(level: manager.level)
        }
    }
    
    private let starImageName = "star.fill"
    private let timeBetweenStarAnimations = 0.2
    private let starAnimationDuration = 0.7
    
}

struct EQDetectivePreGameView_Previews: PreviewProvider {
    static let manager = GameShellManager(level: EQDetectiveLevel.level(2)!)
    static var previews: some View {
        PreGameView(manager: manager)
            .onAppear(perform: {
                manager.level.updateProgress(score: 1200)
            })
    }
}
