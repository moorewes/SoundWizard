//
//  EQDetectivePreGameView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/17/20.
//

import SwiftUI

struct GameShellView<Model>: View where Model: GameViewModeling {
    
    @State var gameViewState: GameViewState = .preGame
    @Binding var showLevel: Bool
    @State var showGameplay = false
    @State var gameCompleted = false
    
    @ObservedObject var manager: Model
    
    var quitText: String {
        switch gameViewState {
        case .inGame:
            return "Quit"
        default:
            return "Back"
        }
    }

    let navPadding = EdgeInsets(top: 5, leading: 30, bottom: 0, trailing: 70)
    
    var body: some View {
        ZStack {
            Color.darkBackground
                .ignoresSafeArea()
            
            VStack {
                
                // Nav Bar
                
                HStack {
                    Button(quitText) {
                        if gameViewState == .inGame {
                            manager.cancelGameplay()
                            gameViewState = .gameQuitted
                        } else {
                            showLevel = false
                        }
                    }
                        .font(.monoBold(18))
                        .foregroundColor(.white)
                    .opacity(0.6)
                    
                    Spacer()
                    
                    Text("Level \(manager.level.levelNumber)")
                        .foregroundColor(.teal)
                        .font(.monoSemiBold(20))
                    
                    Spacer()
                    
                }
                .padding(EdgeInsets(top: 5,
                                    leading: 30,
                                    bottom: 0,
                                    trailing: 70))
                
                // Game or Game Preview
                
                if gameViewState == .inGame {
                    gameplayView()
                } else {
                    PreGameView(manager: manager, gameViewState: $gameViewState)
                }
                
//                if showGameplay && !gameCompleted {
//                    gameplayView()
//                } else {
//                    PreGameView(manager: manager, showGameplay: $showGameplay)
//                }

            }
            
        }
        
    }
    
    @ViewBuilder
    func gameplayView() -> some View {
        if let manager = manager as? EQDetectiveViewModel {
            EQDetectiveGameplayView(manager: manager,
                                    gameViewState: $gameViewState)
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
