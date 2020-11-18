//
//  EQDetectivePreGameView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/17/20.
//

import SwiftUI

struct GameShellView<Model>: View where Model: GameViewModeling {
    
    @Binding var showLevel: Bool
    @State var showGameplay = false
    @State var gameCompleted = false
    
    @ObservedObject var manager: Model

    let navPadding = EdgeInsets(top: 5, leading: 30, bottom: 0, trailing: 70)
    
    var body: some View {
        ZStack {
            Color.darkBackground
                .ignoresSafeArea()
            
            VStack {
                
                // Nav Bar
                
                HStack {
                    Button(showGameplay ? "Quit" : "Back") {
                        if showGameplay {
                            showGameplay = false
                            manager.cancelGameplay()
                        } else {
                            showLevel = false
                        }
                    }
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    .opacity(0.6)
                    
                    Spacer()
                    
                    Text("Level \(manager.level.levelNumber)")
                        .foregroundColor(.teal)
                        .font(.system(size: 20, weight: .semibold))
                    
                    Spacer()
                    
                }
                .padding(EdgeInsets(top: 5,
                                    leading: 30,
                                    bottom: 0,
                                    trailing: 70))
                
                // Game or Game Preview
                
                if showGameplay && !gameCompleted {
                    gameplayView()
                } else {
                    PreGameView(manager: manager, showGameplay: $showGameplay)
                }

            }
            
        }
        
    }
    
    @ViewBuilder
    func gameplayView() -> some View {
        if let manager = manager as? EQDetectiveViewModel {
            EQDetectiveGameplayView(manager: manager,
                                    gameCompleted: $gameCompleted)
        } else {
            Text("no game found")
        }
    }
    
}

struct EQDetectiveShellView_Previews: PreviewProvider {
    static var previews: some View {
        GameShellView(showLevel: .constant(true), manager: EQDetectiveViewModel(level: EQDetectiveLevel.level(0)!))
    }
}
