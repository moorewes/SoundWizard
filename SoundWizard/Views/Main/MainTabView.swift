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
            
            GameBrowser()
                .tabItem {
                    Image(systemName: "star.fill")
                        .background(Color.darkGray)
                    Text("All Games")
                }
        }
        .fullScreenCover(isPresented: $stateController.presentingLevel) {
            GameShellView(level: stateController.level!,
                          gameViewState: $stateController.gameState)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        UITabBar.setCustomAppearance()
        return MainTabView()
    }
}
