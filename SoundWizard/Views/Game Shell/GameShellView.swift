//
//  EQDetectivePreGameView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/17/20.
//

import SwiftUI

struct GameShellView: View {
    
    var game: GameHandling
    
    @State var showInfoView = false
        
    var body: some View {
        ZStack {
            Color.darkBackground
                .ignoresSafeArea()
            
            VStack {
                navBar
                                
                if case .inGame = game.state {
                    GameplayView(level: game.level, completionHandler: game.completionHandler)
                } else if case .gameCompleted = game.state {
                    PostGameView(scoreData: game.level.scoreData, gameHandler: game.startHandler)
                } else {
                    PreGameView(level: game.level, gameHandler: game.startHandler)
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
                game.completionHandler.quitGame()
            }
                .font(.mono(.headline))
                .foregroundColor(.lightGray)
            
            Spacer()
            
            Text("Level \(game.level.number)")
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
        if case .inGame = game.state {
            return "gearshape.fill"
        } else {
            return "info.circle"
        }
    }
    
    var quitText: String {
        switch game.state {
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
