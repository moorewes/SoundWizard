//
//  ButtonStyle.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/21/20.
//

import SwiftUI

struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.black)
            .font(.std(.headline))
            .padding(10)
            .padding(.horizontal, 20)
            .background(
                Color.teal.opacity(configuration.isPressed ? 0.5 : 1))
            .cornerRadius(10)
    }
}


