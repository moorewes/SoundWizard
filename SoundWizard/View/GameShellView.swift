//
//  EQDetectivePreGameView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/17/20.
//

import SwiftUI

struct GameShellView: View {
    
    @Binding var isPresented: Bool
    
    @ObservedObject var manager: GameShellManager
    
    init(isPresented: Binding<Bool>, level: Level) {
        _isPresented = isPresented
        self.manager = GameShellManager(level: level)
    }
        
    var body: some View {
        ZStack {
            Color.darkBackground
                .ignoresSafeArea()
            
            VStack {
                navBar
                
                if manager.gameViewState == .inGame {
                    gameplayView()
                } else {
                    PreGameView(manager: manager)
                }

            }
            
        }
        
    }
    
    var navBar: some View {
        HStack {
            Button(quitText) {
                if manager.gameViewState == .inGame {
                    manager.quitGame()
                } else {
                    isPresented = false
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
    }
    
    @ViewBuilder
    func gameplayView() -> some View {
        if let level = self.manager.level as? EQDetectiveLevel {
            EQDetectiveGameplayView(level: level, gameViewState: $manager.gameViewState)
        } else {
            Text("no game found")
        }
    }
    
    var quitText: String {
        switch manager.gameViewState {
        case .inGame:
            return "Quit"
        default:
            return "Back"
        }
    }

    let navPadding = EdgeInsets(top: 5, leading: 30, bottom: 0, trailing: 70)
    
}

struct EQDetectiveShellView_Previews: PreviewProvider {
    static var previews: some View {
        GameShellView(isPresented: .constant(true), level: EQDetectiveLevel.level(0)!)
    }
}
