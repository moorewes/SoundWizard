//
//  EQDetectivePreGameView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/17/20.
//

import SwiftUI

struct PreGameView: View {
        
    @ObservedObject var manager: GameShellManager
            
    var body: some View {
        ZStack {
            Color.darkBackground
                .ignoresSafeArea()
            
            VStack {
                
                // Top Score
                
                Text("Top Score")
                    .font(.monoMedium(20))
                    .foregroundColor(.white)
                    .opacity(0.6)
                    .padding()
                
                Text("\(manager.level.progress.topScore ?? 0)")
                    .font(.monoBold(48))
                    .foregroundColor(.teal)
                    .padding()
                
                // Stars
                
                HStack {
                    
                    ForEach(0..<3) { i in
                        
                        if i > 0 {
                            Spacer()
                            
                        }
                        
                        VStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(manager.level.progress.starsEarned > i ?
                                                    .yellow :
                                                    .extraDarkGray)
                                .scaleEffect(2.5)
                                .padding(20)
                                .animation(.default)
                            
                            Text("\(manager.level.starScores[i])")
                                .foregroundColor(.teal)
                                .font(.monoBold(20))
                        }
                    }
                    
                }
                .padding(EdgeInsets(top: 5, leading: 80, bottom: 5, trailing: 80))
                
                // Instruction View
                                
                instructionView
                    .foregroundColor(.teal)
                    .background(Color(.darkGray))
                    .cornerRadius(20)
                    .padding(EdgeInsets(top: 50, leading: 50, bottom: 50, trailing: 50))
                                
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
                .padding()
            }
        }
    }
    
    
    private var instructionView: some View {
        switch manager.level.game {
        case .eqDetective:
            return EQDetectiveInstructionView(level: manager.level)
        }
    }
    
}

struct EQDetectivePreGameView_Previews: PreviewProvider {
    static var previews: some View {
        PreGameView(manager: GameShellManager(level: EQDetectiveLevel.level(0)!))
    }
}
