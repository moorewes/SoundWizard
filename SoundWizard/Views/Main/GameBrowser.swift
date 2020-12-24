//
//  GameBrowser.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/13/20.
//

import SwiftUI

struct GameBrowser: View {
    let gameItems: [GameItem]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(gameItems) { item in
                    NavigationLink(destination:
                            LevelBrowser(game: item.game)
                                .primaryBackground()
                        , label: {
                            GameCell(game: item)
                        })
                }
                .listRowBackground(Color.secondaryBackground)
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

struct GamesUIView_Previews: PreviewProvider {
    static var previews: some View {
        GameBrowser(gameItems: [GameItem(game: .eqDetective, stars: StarProgress(total: 12, earned: 8))])
    }
}


