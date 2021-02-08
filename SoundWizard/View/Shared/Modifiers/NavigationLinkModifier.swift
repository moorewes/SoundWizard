//
//  NavigationLinkModifier.swift
//  SoundWizard
//
//  Created by Wes Moore on 1/25/21.
//

import SwiftUI

extension View {
    func navigationLink<Content: View>(isActive: Binding<Bool>, destination: () -> Content) -> some View {
        self.background(
            NavigationLink(
                destination: destination(),
                isActive: isActive,
                label: {})
        )
    }
}
