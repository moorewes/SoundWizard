//
//  EQDetectivePreGameView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/17/20.
//

import SwiftUI

struct GameShellView: View {
    var gameHandler: GameHandling
    @State var showInfoView = false
        
    var body: some View {
        VStack {
            NavBar(game: gameHandler, rightBarButtonAction: { showInfoView.toggle() })
            
            if gameHandler.state.isInGame {
                GameplayView(handler: gameHandler)
            } else if gameHandler.state == .completed {
                PostGameView(scoreData: gameHandler.level.scoreData, gameHandler: gameHandler.startHandler)
            } else {
                PreGameView(level: gameHandler.level, gameHandler: gameHandler.startHandler)
            }
        }
        .background(Gradient.background.ignoresSafeArea())
        .transition(.opacity)
        .fullScreenCover(isPresented: $showInfoView) {
            infoView
                .background(Gradient.background)
        }
    }

    // TODO: Build Settings and Tutorial View
    var infoView: some View {
        Text("Info View")
    }
}

extension GameShellView {
    struct NavBar: View {
        let game: GameHandling
        let rightBarButtonAction: () -> Void
        
        var body: some View {
            HStack {
                Button(quitText) {
                    game.completionHandler.quit()
                }
                    .font(.mono(.headline))
                    .foregroundColor(.lightGray)
                                
                Spacer()
                
                Text("Level \(game.level.number)")
                    .foregroundColor(.teal)
                    .font(.mono(.headline))
                
                Spacer()
                
                Button(action: {
                    rightBarButtonAction()
                }, label: {
                    Image(systemName: infoButtonImageName)
                        .foregroundColor(.extraLightGray)
                        .imageScale(.large)
                })
            }
            .padding(EdgeInsets(top: 5,
                                leading: 30,
                                bottom: 15,
                                trailing: 40))
        }
        
        var infoButtonImageName: String {
            game.state.isInGame ? "gearshape.fill" : "info.circle"
        }
        
        var quitText: String {
            game.state.isInGame ? "Quit" : "Back"
        }
    }
}

struct EQDetectiveShellView_Previews: PreviewProvider {
    static var previews: some View {
        GameShellView(gameHandler: TestData.GameHandler(state: .preGame))
            .background(Color.init(hue: 0.62,
                                   saturation: 0.3,
                                   brightness: 0.18).ignoresSafeArea())
    }
}
