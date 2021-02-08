//
//  PeakingFilterGainSlider.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/24/20.
//

import SwiftUI

struct InteractiveEQPlot: View {
    @Binding var filters: [EQBellFilterData]
    let frequencyRange: FrequencyRange
    let gainRange: ClosedRange<Double>

    var body: some View {
        ZStack {
            BellPath(filters: CGFilters(filters: filters,
                                        frequencyRange: frequencyRange,
                                        gainRange: gainRange))
                .zIndex(0)
            
            HStack(spacing: 0) {
                ForEach(filters.indices, id: \.self) { index in
                    DragZone(filter: $filters[index])
                }
            }
        }
    }
}

extension InteractiveEQPlot {
    struct DragZone: View {
        @Binding var filter: EQBellFilterData
        @State private var dragStart: (x: CGFloat, y: CGFloat)?
        
        var body: some View {
            GeometryReader { geometry in
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.01))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                handleDrag(
                                    x: value.translation.width / geometry.size.width,
                                    y: value.translation.height / geometry.size.height
                                )
                            }
                            .onEnded { _ in dragStart = nil }
                    )
            }
        }
        
        func handleDrag(x dragX: CGFloat, y dragY: CGFloat) {
            if dragStart == nil {
                let x = CGFloat(filter.frequency.octavePercentage(in: filter.frequencyRange) ?? 0)
                let y = CGFloat(filter.gain.dB.percentage(in: filter.dBGainRange) ?? 0)
                dragStart = (x, y)
            }
            let x = (dragStart!.x + dragX * xDragPrecisionFactor).clamped(to: bounds)
            let y = (dragStart!.y - dragY).clamped(to: bounds)
            
            filter.frequency = AudioMath.frequency(percent: Double(x), in: filter.frequencyRange)
            filter.gain.dB = Double(percent: Double(y), in: filter.dBGainRange)
        }
        
        private let xDragPrecisionFactor: CGFloat = 0.85
        private let bounds: ClosedRange<CGFloat> = 0...1
    }
}

struct CGFilters {
    var data: [CGFilterData]
    
    init(filters: [EQBellFilterData],
         frequencyRange: FrequencyRange,
         gainRange: ClosedRange<Double>) {
        data = filters.enumerated().map { (index, filter) in
            let x = CGFloat(filter.frequency.octavePercentage(in: frequencyRange) ?? 0)
            let y = CGFloat(filter.gain.dB.percentage(in: gainRange) ?? 0)
            return CGFilterData(index: index, x: x, y: y, q: CGFloat(filter.q))
        }
    }
}

struct CGFilterData: Hashable {
    let index: Int
    let x: CGFloat
    let y: CGFloat
    let q: CGFloat
}

struct PeakingFilterSlider_Previews: PreviewProvider {
    @State static var filters: [EQBellFilterData] = [
        EQBellFilterData(frequency: 300, gain: Gain(dB: 4), q: 4),
        EQBellFilterData(frequency: 5000, gain: Gain(dB: 4), q: 4)
    ]
    static var previews: some View {
        InteractiveEQPlot(filters: $filters,
                          frequencyRange: BandFocus.all.range,
                          gainRange: -9...9)
            .frame(width: 300, height: 300, alignment: .center)
    }
}
