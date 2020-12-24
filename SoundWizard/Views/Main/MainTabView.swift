//
//  MainTabView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/8/20.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var stateController: StateController
    
    var body: some View {
        TabView() {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            GameBrowser(gameItems: stateController.gameItems)
                .tabItem {
                    Image(systemName: "star.fill")
                        .background(Color.darkGray)
                    Text("All Games")
                }
        }
        .primaryBackground()
        .fullScreenCover(isPresented: $stateController.isPresentingLevel) {
            GameShellView(game: stateController.gameHandler!)
                .primaryBackground()
                .transition(.opacity)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        Appearance.setup()
        return MainTabView()
            .environmentObject(StateController(levelStore: CoreDataManager.shared))
            .preferredColorScheme(.dark)
    }
}
