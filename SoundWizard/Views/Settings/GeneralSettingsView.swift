//
//  GeneralSettingsView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/9/20.
//

import SwiftUI

struct GeneralSettingsView: View {
    var body: some View {
        NavigationView {
            List() {
                
                SettingsNavigationCell(title: "Imported Audio") {
                    ImportedAudioView()
                }

            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingsNavigationCell<Destination: View>: View {
    
    let title: String
    let destination: Destination
    
    init(title: String, destination: () -> Destination) {
        self.title = title
        self.destination = destination()
    }
    
    var body: some View {
        ZStack {
            NavigationLink(destination: destination) { EmptyView() }
                .opacity(0)
            
            HStack {
                            
                Text(title)
                    .font(.std(.body))
                    .foregroundColor(.white)
                    .frame(width: nil, height: 50, alignment: .center)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.lightGray)
            }
        }
        .listRowBackground(Color.darkGray)
    }
    
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
            .environment(\.sizeCategory, ContentSizeCategory.extraLarge)
    }
}
