//
//  GamesUIView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/13/20.
//

import SwiftUI

struct AllGamesView: View {
    
    @EnvironmentObject private var stateController: StateController
    @ObservedObject private var manager = GamesManager()
    
    private var games: [Game] { manager.games }

    var body: some View {
        NavigationView {
            List {
                ForEach(stateController.gameItems) { game in
                    NavigationLink(
                        destination: LevelsView(levels: game.levels),
                        label: {
                            GameCell(game: game)
                        })
                }
                .listRowBackground(Color.listRowBackground)
                
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Games", displayMode: .inline)
            .navigationBarItems(trailing: settingsBarItem)
        }
    }
    
    private var settingsBarItem: some View {
        SettingsNavLink(destination: GeneralSettingsView())
    }
    
}

struct LevelsView: View {
    
    var levels: [Level]
    
    var body: some View {
        let game = levels.first?.game
        
        if game == nil {
            EmptyView()
        } else if game == .some(.eqDetective) {
            EQDetectiveLevelsView(levels: levels as! [EQDetectiveLevel])
        }
    }
    
//    @ViewBuilder
//    func content() -> some View {
//        let game = levels.first?.game
//
//        if game == nil {
//            EmptyView()
//        } else if game == .some(.eqDetective) {
//            EQDetectiveLevelsView(levels: levels as! [EQDetectiveLevel])
//        }
//    }
    
}



struct GamesUIView_Previews: PreviewProvider {
    static var previews: some View {
        AllGamesView()
    }
}
