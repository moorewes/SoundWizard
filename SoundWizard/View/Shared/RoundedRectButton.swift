//
//  RoundedRectButton.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/14/20.
//

import SwiftUI


struct RoundedRectButton: View {
    let title: String
    var textColor = Color.black
    var backgroundColor = Color.teal
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(title)
                .font(.mono(.headline))
                .foregroundColor(textColor)
                .frame(width: 200, height: 50, alignment: .center)
                .background(backgroundColor)
                .cornerRadius(10)
        })
    }
}

struct RoundedRectButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RoundedRectButton(title: "Default", action: {})
                .padding()
            
            RoundedRectButton(title: "Hi",
                              textColor: .white,
                              backgroundColor: .gray) {}
        }
    }
}
