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
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.teal)
                    .padding()
                
                Text("\(manager.level.progress.topScore ?? 0)")
                    .font(.system(size: 48, weight: .black, design: .monospaced))
                    .foregroundColor(.teal)
                
                // Stars
                
                HStack {
                    
                    ForEach(0..<3) { i in
                        
                        if i > 0 {
                            Spacer()
                            
                        }
                        
                        VStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(manager.level.progress.starsEarned > i ? .yellow : .black)
                                .scaleEffect(3.0)
                                .padding(40)
                            
                            Text("\(manager.level.starScores[i])")
                                .foregroundColor(.teal)
                                .font(.system(size: 22,
                                              weight: .bold,
                                              design: .monospaced))
                        }
                    }
                    
                }
                .padding(EdgeInsets(top: 5, leading: 40, bottom: 5, trailing: 40))
                
                // Instruction View
                
                Spacer()
                
                instructionView
                    .foregroundColor(.teal)
                
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
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(.darkBackground)
                    }
                    
                })
                
                
                
            }
        }
    }
    
    private var instructionView: some View {
        switch manager.level.game {
        case .eqDetective:
            return EQDetectiveInstructionView()
        
        }
    }
    
}

struct EQDetectivePreGameView_Previews: PreviewProvider {
    static var previews: some View {
        PreGameView(manager: EQDetectiveViewModel(level: EQDetectiveLevel.level(0)!), showGameplay: .constant(false))
    }
}
