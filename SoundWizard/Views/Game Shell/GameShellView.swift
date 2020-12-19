//
//  EQDetectivePreGameView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/17/20.
//

import SwiftUI

struct GameShellView: View {
    
    var level: Level
    @Binding var gameViewState: GameViewState
    
    @EnvironmentObject var stateController: StateController
    @Environment(\.presentationMode) private var presentationMode
    @State var showInfoView = false
        
    var body: some View {
        ZStack {
            Color.darkBackground
                .ignoresSafeArea()
            
            VStack {
                navBar
                                
                if case .inGame = gameViewState {
                    GameplayView(level: level.levelVariant, completion: stateController.finishGame)
                } else if case .gameCompleted = gameViewState {
                    PostGameView(level: level, gameViewState: $gameViewState, startGameAction: stateController.startGame)
                } else {
                    PreGameView(level: level, startGame: stateController.startGame)
                }

            }
            
        }
        .fullScreenCover(isPresented: $showInfoView) {
            infoView
        }
        
    }
    
    
    var navBar: some View {
        HStack {
            Button(quitText) {
                if case .inGame = gameViewState {
                    stateController.quitGame()
                } else {
                    presentationMode.wrappedValue.dismiss()
                }
            }
                .font(.mono(.headline))
                .foregroundColor(.lightGray)
            
            Spacer()
            
            Text("Level \(level.number)")
                .foregroundColor(.teal)
                .font(.mono(.headline))
            
            Spacer()
            
            Button(action: {
                showInfoView = true
            }, label: {
                Image(systemName: infoButtonImageName)
                    .foregroundColor(.extraLightGray)
                    .imageScale(.large)
            })
            
        }
        .padding(EdgeInsets(top: 5,
                            leading: 30,
                            bottom: 0,
                            trailing: 40))
    }

    var infoView: some View {
        Text("Info View")
    }
    
    var infoButtonImageName: String {
        if case .inGame = gameViewState {
            return "gearshape.fill"
        } else {
            return "info.circle"
        }
    }
    
    var quitText: String {
        switch gameViewState {
        case .inGame:
            return "Quit"
        default:
            return "Back"
        }
    }

    let navPadding = EdgeInsets(top: 5, leading: 30, bottom: 0, trailing: 70)
    
}
//
//struct EQDetectiveShellView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameShellView(level: TestLevel(), isPresented: .constant(true))
//    }
//}
