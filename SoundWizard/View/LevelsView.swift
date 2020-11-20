//
//  LevelsView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/13/20.
//

import SwiftUI

struct LevelsView: View {
    
    @ObservedObject var manager: LevelsViewModel
    @State private var showLevel = false
        
    init(game: Game) {
        manager = LevelsViewModel(game: game)
        configureNavBar()
    }
    
    var body: some View {
        ZStack {
            Color(.darkGray)
                .ignoresSafeArea()
            
            VStack {
                List() {
                    ForEach(manager.levels, id: \.levelNumber) { level in
                        LevelCellView(level: level) {
                            print("tapped on level \(level.levelNumber)")
                            manager.selectedLevel = level
                            showLevel = true
                        }
                    }
                    .frame(width: nil, height: 50, alignment: .center)
                    .listRowBackground(Color(white: 0.3, opacity: 1))
                    
                }
                .listStyle(InsetGroupedListStyle())
                
            }
            .navigationBarTitle("EQ Detective", displayMode: .inline)
            .fullScreenCover(isPresented: $showLevel, onDismiss: {
                manager.selectedLevel = nil
            }, content: {
                gameShellView(for: manager.selectedLevel!)
            })

            
        }
        
    }
    
    
    private func gameShellView(for level: Level) -> some View {
        let manager = level.game.viewModel(level: level)
        return GameShellView(showLevel: $showLevel, manager: manager)
    }
    
    private func configureNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.darkBackground)
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(Color.darkBackground),
            .font: UIFont.systemFont(ofSize: 20, weight: .black)
        ]
        
        appearance.largeTitleTextAttributes = attrs
        
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UITableView.appearance().backgroundColor = UIColor(Color.darkBackground)
        UITableViewCell.appearance().backgroundColor = UIColor(Color.darkBackground)
    }
    
}

struct LevelCellView: View {
    
    var level: Level
    var tapHandler: () -> Void
    
    var body: some View {
        ZStack {
            Color(white: 0.3, opacity: 1)
                .onTapGesture(perform: tapHandler)
            
            HStack {
                Text("Level \(level.levelNumber)")
                    .font(.monoSemiBold(20))
                    .foregroundColor(.teal)
                
                Spacer()
                Spacer()
                
                VStack(alignment: .trailing) {
                    
                    Text("\(level.audioSource.description)")
                        .font(.monoMedium(12))
                        .foregroundColor(.teal)
                        .offset(x: 0, y: -5)
                    
                    HStack {
                        ForEach(0..<3) { i in
                            Image(systemName: "star.fill")
                                .foregroundColor(level.progress.starsEarned > i ? .yellow : .black)
                        }
                    }
                    
                    
                    
                }
                .frame(width: 200, height: 60, alignment: .trailing)
                    
                
                .offset(x: -10, y: 0)
            }
            
        }
    }
}

struct LevelsView_Previews: PreviewProvider {
    static var previews: some View {
        LevelsView(game: .eqDetective)
    }
}
