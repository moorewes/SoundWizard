//
//  MainSettingsView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/9/20.
//

import SwiftUI

struct MainSettingsView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    NavigationRowCell(title: "Imported Audio") {
                        ImportedAudioView()
                    }
                }
            }
            .background(Gradient.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(.std(.title3))
                }
            })
        }
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        MainSettingsView()
    }
}
