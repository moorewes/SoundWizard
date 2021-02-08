//
//  MovingCounter.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/19/20.
//

import SwiftUI

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
