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
                        LevelCellView(level: level)
                            .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                                showLevel = true
                            })
                            .fullScreenCover(isPresented: $showLevel) {
                                gameShellView(for: level)
                            }
                            
                        
                    }
                    .frame(width: nil, height: 50, alignment: .center)
                    .listRowBackground(Color(white: 0.3, opacity: 1))
                    
                }
                .listStyle(InsetGroupedListStyle())
                
            }
            .navigationBarTitle("EQ Detective", displayMode: .inline)
            
        }
    }
    
    private func gameShellView(for level: Level) -> some View {
        switch level.game {
        case .eqDetective:
            let manager = EQDetectiveViewModel(level: level)
            return GameShellView(showLevel: $showLevel, manager: manager)
        }
        
       
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
    }
    
}

struct LevelCellView: View {
    
    var level: Level
    
    var body: some View {
        HStack {
            Text("Level \(level.levelNumber)")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.teal)
            
            Spacer()
            Spacer()
                
            ForEach(0..<3) { i in
                Image(systemName: "star.fill")
                    .foregroundColor(level.progress.starsEarned > i ? .yellow : .black)
            }
            .offset(x: -10, y: 0)
        }
    }
}

struct LevelsView_Previews: PreviewProvider {
    static var previews: some View {
        LevelsView(game: .eqDetective)
    }
}
