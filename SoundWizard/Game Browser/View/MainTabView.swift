//
//  MainTabView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/8/20.
//

import SwiftUI

struct MainTabView: View {
    
    @State var selectedTab: Int = 1
    
    var body: some View {
        TabView() {
            
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            AllGamesView()
                .tabItem {
                    Image(systemName: "star.fill")
                        .background(Color.darkGray)
                    Text("All Games")
                }
            
        }
        .onAppear {
            UITabBar.appearance().barTintColor = UIColor(Color.darkBackground)
            UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
            UITabBar.appearance().tintColor = UIColor(Color.teal)
        }
        
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}