//
//  FrequencyDragGesture.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/7/20.
//

import SwiftUI

struct FrequencyDragGesture: ViewModifier {
    @Binding var frequency: Frequency
    let range: FrequencyRange
    @State private var dragStartPercentage: CGFloat?
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            handleDragChange(offset: value.translation.width,
                                             width: geometry.size.width)
                        }
                        .onEnded { value in
                            dragStartPercentage = nil
                        }
                )
        }
    }
    
    func handleDragChange(offset: CGFloat, width: CGFloat) {
        if dragStartPercentage == nil {
            dragStartPercentage = CGFloat(frequency.percentage(in: range))
        }
        let percentOffset = offset / width
        let percent = Double(dragStartPercentage! + percentOffset)
        updateFrequency(percent: percent)
    }
    
    func updateFrequency(percent: Double) {
        let freq = AudioMath.frequency(percent: percent, in: range, uiRounded: true)
        frequency = freq.clamped(to: range)
    }
}

extension View {
    func frequencyDragGesture(frequency: Binding<Frequency>, range: FrequencyRange) -> some View {
        self.modifier(
            FrequencyDragGesture(frequency: frequency, range: range)
        )
    }
}
