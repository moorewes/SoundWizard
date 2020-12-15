//
//  EQDetectivePreGameView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/17/20.
//

import SwiftUI

struct GameShellView: View {
    
    var level: Level
    
    @Binding var isPresented: Bool
    @State var gameViewState: GameViewState = .preGame
    @State var showInfoView = false
    
    init(level: Level, isPresented: Binding<Bool>) {
        self.level = level
        self._isPresented = isPresented
       // self.game = level.makeGame()
    }
        
    var body: some View {
        ZStack {
            Color.darkBackground
                .ignoresSafeArea()
            
            VStack {
                navBar
                
                if gameViewState == .inGame {
                    gameplayView()
                } else if gameViewState == .gameCompleted {
                    PostGameView(level: level, gameViewState: $gameViewState)
                } else {
                    PreGameView(level: level, gameViewState: $gameViewState)
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
                if gameViewState == .inGame {
                    gameViewState = .gameQuitted
                } else {
                    isPresented = false
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
    
    @ViewBuilder
    func gameplayView() -> some View {
        if let level = level as? EQDetectiveLevel {
            EQDetectiveGameplayView(level: level, gameViewState: $gameViewState, practicing: false)
        } else {
            Text("no game found")
        }
    }
    
//    var title: String {
//        if gameViewState == .inGame {
//            if
//        }
//    }
    
    var infoView: some View {
        Text("Info View")
    }
    
    var infoButtonImageName: String {
        if gameViewState == .inGame {
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
