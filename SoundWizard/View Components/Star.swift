//
//  Star.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/2/20.
//

import SwiftUI

struct Star: View {
    
    var filled: Bool
    var number: Int?
    var animated: Bool
    var animationDelay: Double = 0
        
    @State private var readyToAnimate = false
    
    private var shouldFill: Bool {
        return filled && ( !animated || readyToAnimate )
    }
    
    private var shouldAnimate: Bool {
        return filled && animated && readyToAnimate
    }
        
    var body: some View {
        Image(systemName: imageName)
            .foregroundColor(.white)
            .colorMultiply(shouldFill ? .yellow : .extraDarkGray)
            .animation(animated ? .easeIn(duration: 3.0) : nil)
            .rotation3DEffect(
                shouldAnimate ? .degrees(360) : .zero,
                axis: (x: 0.0, y: shouldFill ? 1.0 : 0, z: 0.0)
            )
            .animation(animated ? .spring(response: 1.5, dampingFraction: 0.8, blendDuration: 0) : nil)
            .pulse(active: shouldAnimate, duration: pulseAnimationDuration)
            .onAppear {
                guard animated else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
                    self.readyToAnimate = true
                    if let number = self.number {
                        Conductor.master.fireWinStarFeedback(star: number)
                    }
                }
            }
    }
    
    private let imageName = "star.fill"
    private let pulseAnimationDuration = 0.7
    private let rotationAnimationDuration = 1.5
    
}

struct Star_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.darkBackground.ignoresSafeArea()
            Star(filled: true, number: 1, animated: true, animationDelay: 0)
                .frame(width: 50, height: 50, alignment: .center)
                .font(.system(size: 80))
                .transition(.slide)
        }
        
    }
}
