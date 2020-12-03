//
//  MovingCounter.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/19/20.
//

import SwiftUI

// Adapted from: https://gist.github.com/swiftui-lab/e5901123101ffad6d39020cc7a810798
// Article: https://swiftui-lab.com/swiftui-animations-part3/
struct MovingCounter: View {
    let number: Int
    
    var body: some View {
        Text("000")
            .modifier(MovingCounterModifier(number: Double(number)))
    }
    
    struct MovingCounterModifier: AnimatableModifier {

        var number: Double
        
        var animatableData: Double {
            get { number }
            set { number = newValue }
        }
        
        func body(content: Content) -> some View {
            let n = Int(number)
            
            let digits = String(format: "%04d", n)
            let font = Font.monoMedium(22)
            
            return HStack() {
                Text(digits)
                    .font(font)
                    .foregroundColor(.teal)
            }
        }

    }

}

