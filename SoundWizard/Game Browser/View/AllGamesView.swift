//
//  GamesUIView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/13/20.
//

import SwiftUI

struct AllGamesView: View {
    
    @ObservedObject private var manager = GamesManager()
    
    private var games: [Game] { manager.games }

    var body: some View {
        NavigationView {
            List {
                ForEach(games) { game in
                    NavigationLink(
                        destination: LevelsView(game: .eqDetective),
                        label: {
                            gameCell(game)
                        })
                }
                .listRowBackground(Color.listRowBackground)
                
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Games", displayMode: .inline)
            .navigationBarItems(trailing: settingsButton)
        }

    }
    
    private func gameCell(_ game: Game) -> some View {
        HStack {
            Text(game.name)
                .font(.std(.headline))
                .foregroundColor(.teal)
                .padding(.vertical, 30)
            
            Spacer()
            
            Star(filled: true, animated: false)
                .font(.system(size: 14))
            
//            Text(manager.starProgress(game: game))
//                .font(.mono(.subheadline))
//                .foregroundColor(.lightGray)
//                .padding(.trailing, 15)
        }
    }
    
    private var settingsButton: some View {
        NavigationLink(destination: GeneralSettingsView()) {
            Image(systemName: "gearshape.fill")
                .imageScale(.medium)
                .foregroundColor(.lightGray)
                .padding(.trailing, 15)
        }
    }
    
}

struct GamesUIView_Previews: PreviewProvider {
    static var previews: some View {
        AllGamesView()
    }
}
