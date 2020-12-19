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
        ScrollView() {
            VStack {
                Text("Today's Practice")
                    .font(.std(.title2))
                    .foregroundColor(.teal)
                    .padding(.top, 20)
                
                LevelPicker(levels: stateController.dailyLevels) { level in
                    stateController.playLevel(level)
                }
            }
        }
        .background(Color.darkBackground.ignoresSafeArea())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(StateController())
    }
}
