//
//  HomeView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/8/20.
//

import SwiftUI

class HomeViewManager: ObservableObject {
    
    var dailyLevels: [Level] = []
    
    @Published var selectedLevel: Level? {
        didSet {
            showLevel = selectedLevel != nil
        }
    }
    
    @Published var showLevel = false
    
    func select(_ level: Level) {
        selectedLevel = level
    }
    
    func dismissLevel() {
        selectedLevel = nil
    }
    
    init() {
        generateDailyLevels()
    }
    
    // TODO: Implement real algorithm
    func generateDailyLevels() {
        let predicate = NSPredicate(format: "number < 4")
        dailyLevels = EQDetectiveLevel.levels(matching: predicate)
    }
    
}

struct HomeView: View {
    
    @ObservedObject var manager = HomeViewManager()
        
    var body: some View {
        
        ScrollView() {
            
            VStack {
                Text("Today's Practice")
                    .font(.std(.title2))
                    .foregroundColor(.teal)
                LevelsHorizontalList(levels: manager.dailyLevels) { level in
                    manager.select(level)
                }
                
            }
            
        }
        .background(Color.darkBackground.ignoresSafeArea())
        .fullScreenCover(isPresented: $manager.showLevel, onDismiss: {
            manager.dismissLevel()
        }, content: {
            GameShellView(isPresented: $manager.showLevel, level: manager.selectedLevel!)
        })
        
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
