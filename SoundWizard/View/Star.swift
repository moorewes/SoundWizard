//
//  Star.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/2/20.
//

import SwiftUI

struct Star: View {
    
    var number: Int
    var filled: Bool
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
            .animation(.easeIn(duration: 3.0))
            .rotation3DEffect(
                shouldAnimate ? .degrees(360) : .zero,
                axis: (x: 0.0, y: shouldFill ? 1.0 : 0, z: 0.0)
            )
            .animation(.spring(response: 1.5, dampingFraction: 0.8, blendDuration: 0))
            .pulse(active: shouldAnimate, duration: pulseAnimationDuration)
            .onAppear {
                guard animated else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
                    self.readyToAnimate = true
                    Conductor.shared.fireWinStarFeedback(star: number)
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
            Star(number: 1, filled: true, animated: true, animationDelay: 0)
                .frame(width: 50, height: 50, alignment: .center)
                .font(.system(size: 80))
                .transition(.slide)
        }
        
    }
}
