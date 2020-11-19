//
//  EQDetectivePreGameView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/17/20.
//

import SwiftUI

struct PreGameView<Model>: View where Model: GameViewModeling {
        
    @ObservedObject var manager: Model
    
    @Binding var showGameplay: Bool
        
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
                                .foregroundColor(manager.level.progress.starsEarned > i ? .yellow : .extraDarkGray)
                                .scaleEffect(2.5)
                                .padding(20)
                            
                            Text("\(manager.level.starScores[i])")
                                .foregroundColor(.teal)
                                .font(.monoBold(20))
                        }
                    }
                    
                }
                .padding(EdgeInsets(top: 5, leading: 80, bottom: 5, trailing: 80))
                
                // Instruction View
                
                Spacer()
                
                instructionView
                    .foregroundColor(.teal)
                    .background(Color(.darkGray))
                    .cornerRadius(20)
                    .padding(EdgeInsets(top: 50, leading: 50, bottom: 50, trailing: 50))
                
                Spacer()
                
                // Start Button
                
                Button(action: {
                    showGameplay = true
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
        PreGameView(manager: EQDetectiveViewModel(level: EQDetectiveLevel.level(2)!), showGameplay: .constant(false))
    }
}
