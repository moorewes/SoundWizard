//
//  GameBrowser.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/13/20.
//

import SwiftUI

struct GameBrowser: View {
    let games: [Game.Data]
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            List(games: games)
                .navigationLink(isActive: $showSettings) { MainSettingsView() }
                .background(Gradient.background.ignoresSafeArea())
                .navigationBarHidden(true)
        }
    }
}

// MARK: - List
extension GameBrowser {
    struct List: View {
        let games: [Game.Data]
        
        var body: some View {
            ScrollView {
                VStack {
                    SectionSimpleHeader(title: "Games")
                    
                    ForEach(games) { game in
                        
                        NavigationLink(
                            destination:
                                LevelBrowser(game: game.game)
                                .background(Gradient.background.ignoresSafeArea()),
                            label: {
                                Cell(title: game.game.name, starsLabel: game.stars.uiDescription)
                            })
                    }
                    .padding(.horizontal)
                    .background(Color.secondaryBackground)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
            }
        }
    }
}

// MARK: - List Cell
extension GameBrowser.List {
    struct Cell: View {
        let title: String
        let starsLabel: String
        
        var body: some View {
            RowCell {
                HStack {
                    Text(title)
                        .font(.std(.headline))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    StarImage()
                    Text(starsLabel)
                        .font(.mono(.subheadline))
                        .foregroundColor(.teal)
                }
            }
        }
    }
}

// MARK: - Preview
struct GamesUIView_Previews: PreviewProvider {
    static var previews: some View {
        GameBrowser(games: [Game.Data(game: Game.eqMatch,
                                         stars: StarProgress(total: 12, earned: 8))])
    }
}
