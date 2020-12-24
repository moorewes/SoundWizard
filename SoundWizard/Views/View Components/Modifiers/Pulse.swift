//
//  Pulse.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/2/20.
//

import SwiftUI

struct Pulse: ViewModifier {
    var active: Bool = true
    var scale: CGFloat = 1.5
    var duration: Double = 0.5
    var delay: Double = 0.0
    var repeats: Int = 0
        
    @State var animating = false
    
    func body(content: Content) -> some View {
        return content
            .scaleEffect(animating ? scale : 1)
            .animation(active ? Animation.easeIn(duration: duration / 2).delay(delay) : nil)
            .onAppear(perform: {
                if active {
                    scheduleAnimations()
                }
            })
    }
    
    private func scheduleAnimations() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            animating = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            animating = false
        }
    }
}

extension View {
    func pulse(active: Bool = true, scale: CGFloat = 1.5, duration: Double = 0.5, delay: Double = 0.0, repeats: Int = 0) -> some View {
        self.modifier(Pulse(active: active, scale: scale, duration: duration, delay: delay, repeats: repeats))
    }
}
