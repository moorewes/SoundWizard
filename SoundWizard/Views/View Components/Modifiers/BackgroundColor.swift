//
//  BackgroundColor.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/19/20.
//

import SwiftUI

struct CustomBackground: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .background(color.ignoresSafeArea())
    }
}

extension View {
    func primaryBackground() -> some View {
        self.modifier(CustomBackground(color: .darkBackground))
    }
    func secondaryBackground() -> some View {
        self.modifier(CustomBackground(color: .secondaryBackground))
    }
}
