//
//  MovingCounter.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/19/20.
//

import SwiftUI

// Loosely Adapted from: https://gist.github.com/swiftui-lab/e5901123101ffad6d39020cc7a810798
// Article: https://swiftui-lab.com/swiftui-animations-part3/
struct MovingCounter: View {
    
    var number: Int
    let font: Font
    var duration: Double = 0.75
    
    var body: some View {
        Text("000")
            .modifier(MovingCounterModifier(number: number, font: font))
            .animation(.easeOut(duration: duration))
    }

}

struct MovingCounterModifier: AnimatableModifier {

    var number: Int
    let font: Font
    
    var animatableData: Double {
        get { Double(number) }
        set { number = Int(newValue) }
    }
    
    func body(content: Content) -> some View {
        Text(String(format: "%04d", number))
            .font(self.font)
            .foregroundColor(.teal)
    }

}
