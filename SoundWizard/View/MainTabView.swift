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
                .tabItem { HomeItem() }
            
            GameBrowser(games: stateController.gameData)
                .tabItem { GameBrowserItem() }
            
            MainSettingsView()
                .tabItem { SettingsItem() }
        }
        .accentColor(.white)
        .fullScreenCover(item: $stateController.gameHandler, content: { handler in
            GameShellView(gameHandler: handler)
        })
    }
}

// MARK: - Tab Bar Items
extension MainTabView {
    struct HomeItem: View {
        var body: some View {
            Image(systemName: "house.fill")
            Text("Home")
        }
    }
    
    struct GameBrowserItem: View {
        var body: some View {
            Image(systemName: "star.fill")
            Text("All Games")
        }
    }
    
    struct SettingsItem: View {
        var body: some View {
            Image(systemName: "gearshape.fill")
            Text("Settings")
        }
    }
}

// MARK: - Preview
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        UIKitAppearance.setup()
        return MainTabView()
            .environmentObject(StateController(levelStore: CoreDataManager.shared))
            .preferredColorScheme(.dark)
    }
}
