//
//  LevelsView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/13/20.
//

import SwiftUI

struct LevelsView: View {
    
    @ObservedObject var manager: LevelsViewModel
        
    init(game: Game) {
        manager = LevelsViewModel(game: game)
    }
    
    var body: some View {
        ZStack {
            Color(.darkGray)
                .ignoresSafeArea()
            
            VStack {
                List() {
                    ForEach(manager.levels, id: \.levelNumber) { level in
                        LevelCellView(level: level) {
                            manager.selectLevel(level)
                        }
                    }
                    .frame(width: nil, height: 50, alignment: .center)
                    .listRowBackground(Color(white: 0.3, opacity: 1))
                    
                }
                .listStyle(InsetGroupedListStyle())
                
            }
            .navigationBarTitle(manager.game.name, displayMode: .inline)
            .fullScreenCover(isPresented: $manager.showLevel, onDismiss: {
                manager.dismissLevel()
            }, content: {
                gameShellView(for: manager.selectedLevel!)
            })

            
        }
        
    }
    
    private func gameShellView(for level: Level) -> some View {
        return GameShellView(isPresented: $manager.showLevel, level: level)
    }
    
}

struct LevelsView_Previews: PreviewProvider {
    static var previews: some View {
        LevelsView(game: .eqDetective)
    }
}
