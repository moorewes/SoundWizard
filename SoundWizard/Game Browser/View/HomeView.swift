//
//  HomeView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/8/20.
//

import SwiftUI
import CoreData

class HomeViewManager: ObservableObject {
        
    @Published var selectedLevel: Level? {
        didSet {
            showLevel = selectedLevel != nil
        }
    }
    
    @Published var showLevel = false
    
    var dailyLevelFetchPredicate: NSPredicate {
        NSPredicate(format: "number < 4")
    }
    
    func select(_ level: Level) {
        selectedLevel = level
    }
    
    func dismissLevel() {
        selectedLevel = nil
    }
    
    init() {
    }
    
}

struct HomeView: View {
    
    @ObservedObject var manager = HomeViewManager()
    @FetchRequest var dailyLevels: FetchedResults<EQDetectiveLevel>
    
    init() {
        let request: NSFetchRequest<EQDetectiveLevel> = EQDetectiveLevel.fetchRequest()
        request.predicate = NSPredicate(format: "number_ < 4")
        request.sortDescriptors = [NSSortDescriptor(key: "number_", ascending: true)]
        _dailyLevels = FetchRequest(fetchRequest: request)
    }
        
    var body: some View {
        
        ScrollView() {
            
            VStack {
                Text("Today's Practice")
                    .font(.std(.title2))
                    .foregroundColor(.teal)
                LevelsHorizontalList(levels: dailyLevels.map { $0 }) { level in
                    manager.select(level)
                }
                
            }
            
        }
        .background(Color.darkBackground.ignoresSafeArea())
        .fullScreenCover(isPresented: $manager.showLevel, onDismiss: {
            manager.dismissLevel()
        }, content: {
            GameShellView(level: manager.selectedLevel!, isPresented: $manager.showLevel)
        })
        
    }
    
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
