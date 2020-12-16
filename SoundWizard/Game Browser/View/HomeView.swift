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
                LevelsHorizontalList(levels: stateController.dailyLevels.map { $0 }) { level in
                    stateController.level = level
                }
            }
        }
        .background(Color.darkBackground.ignoresSafeArea())
        .fullScreenCover(isPresented: $stateController.presentingLevel) {
            GameShellView(level: stateController.level!)
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
