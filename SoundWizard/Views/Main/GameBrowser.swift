//
//  GameBrowser.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/13/20.
//

import SwiftUI

struct GameBrowser: View {
    
    @EnvironmentObject private var stateController: StateController
    
    var body: some View {
        NavigationView {
            List {
                ForEach(stateController.gameItems) { item in
                    NavigationLink(
                        destination: LevelBrowser(game: item.game),
                        label: {
                            GameCell(game: item)
                            
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

struct GamesUIView_Previews: PreviewProvider {
    static var previews: some View {
        GameBrowser()
    }
}
