//
//  NavigationBarItems.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/15/20.
//

import SwiftUI

struct SettingsNavLink<Destination: View>: View {
    var destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            Image(systemName: "gearshape.fill")
                .imageScale(.medium)
                .foregroundColor(.lightGray)
                .padding(.trailing, 15)
        }
    }
    
}
