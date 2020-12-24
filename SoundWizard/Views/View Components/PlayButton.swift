//
//  PlayButton.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/11/20.
//

import SwiftUI

struct PlayButton: View {
    let title: String
    let action: () -> Void
        
    var body: some View {
        Button(action: {
            action()
        }, label: {
            ZStack {
                Rectangle()
                    .foregroundColor(.teal)
                    .cornerRadius(10)
                    .frame(width: 200, height: 50, alignment: .center)
                Text(title)
                    .font(.mono(.headline))
                    .foregroundColor(.primaryBackground)
            }
        })
    }
}
