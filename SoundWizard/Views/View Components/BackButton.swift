//
//  BackButton.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/25/20.
//

import SwiftUI

struct BackButton: View {
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    presentation.wrappedValue.dismiss()
                    
                }
            }, label: {
                Text("Quit")
                    .font(.mono(.headline))
            })
            
        }
    }
}
