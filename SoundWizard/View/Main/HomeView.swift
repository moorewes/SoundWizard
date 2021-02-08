//
//  HomeView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/8/20.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @EnvironmentObject var stateController: StateController
    
    var body: some View {
        NavigationView {
            ScrollView() {
                VStack {
                    Spacer(minLength: topSpace)
                    
                    SectionSimpleHeader(title: "Today's Games")
                    
                    LevelPicker(levels: stateController.dailyLevels) { level in
                        stateController.openLevel(level)
                    }
                    .padding(.bottom)
                    
                    SectionSimpleHeader(title: "Level Packs")
                    
                    LevelPackPicker(packs: stateController.levelPacks) { pack in
                        LevelPackView(pack: pack) { level in
                            stateController.openLevel(level)
                        }
                    }
                }
            }
            .background(Gradient.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
    
    private var topSpace: CGFloat = 50
}

extension HomeView {
    struct SectionTitle: View {
        let title: String
        
        init(_ title: String) {
            self.title = title
        }
        
        var body: some View {
            Text(title)
                .font(.std(.title2))
                .foregroundColor(.teal)
                .padding(.top, HomeView.Design.sectionSpacing)
        }
    }
}

extension HomeView {
    enum Design {
        static let sectionSpacing: CGFloat = 20
        static let cornerRadius: CGFloat = 20
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(StateController(levelStore: CoreDataManager.shared))
            .accentColor(.teal)
    }
}
