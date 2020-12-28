//
//  PeakingFilterGainSlider.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/24/20.
//

import SwiftUI

struct InteractiveEQPlot: View {
    @Binding var filters: [EQBellFilterData]

    var body: some View {
        ZStack {
            BellPath(filters: CGFilters(filters: filters))
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
                let x = CGFloat(filter.frequency.percentage(in: filter.frequencyRange))
                let y = CGFloat(filter.gain.dB / filter.dBGainRange.upperBound) / 2 + 0.5
                dragStart = (x, y)
            }
            let x = (dragStart!.x + dragX).clamped(to: 0...1)
            let y = (dragStart!.y - dragY).clamped(to: 0...1)
            
            filter.frequency = AudioMath.frequency(percent: Float(x), in: filter.frequencyRange)
            filter.gain.dB = filter.dBGainRange.upperBound * Float(y - 0.5) * 2
        }
    }
}

struct CGFilters {
    var data: [CGFilterData]
    
    init(filters: [EQBellFilterData]) {
        let frequencyRange = filters.frequencyRange
        let gainRange = filters.gainRange
        data = filters.enumerated().map { (index, filter) in
            let x = CGFloat(filter.frequency.percentage(in: frequencyRange))
            let y = CGFloat(filter.gain.dB / gainRange.upperBound) / 2 + 0.5
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



private extension Array where Element == EQBellFilterData {
    var frequencyRange: FrequencyRange {
        if self.isEmpty { return BandFocus.all.range }
        let min = self.reduce(BandFocus.all.range.upperBound) { min, data in
            let this = data.frequencyRange.lowerBound
            return this < min ? this : min
        }
        let max = self.reduce(BandFocus.all.range.lowerBound) { max, data in
            let this = data.frequencyRange.upperBound
            return this > max ? this : max
        }
        return min...max
    }
    
    var gainRange: ClosedRange<Float> {
        if self.isEmpty { return 0...0 }
        var min: Float = 0
        var max: Float = 0
        self.forEach { data in
            if data.dBGainRange.lowerBound < min {
                min = data.dBGainRange.lowerBound
            }
            if data.dBGainRange.upperBound > max {
                max = data.dBGainRange.upperBound
            }
        }
        return min...max
    }
}

private extension EQBellFilterData {
//    func x(in range: FrequencyRange) -> CGFloat {
//        CGFloat(frequency.percentage(in: range))
//    }
//
//    func y(in range: ClosedRange<Float>) -> CGFloat {
//        CGFloat(gain.dB / range.upperBound) / 2 + 0.5
//    }
}

struct PeakingFilterSlider_Previews: PreviewProvider {
    @State static var filters: [EQBellFilterData] = [
        EQBellFilterData(frequency: 300, gain: Gain(dB: 4), q: 4),
        EQBellFilterData(frequency: 5000, gain: Gain(dB: 4), q: 4)
    ]
    static var previews: some View {
        InteractiveEQPlot(filters: $filters)
            .frame(width: 300, height: 300, alignment: .center)
    }
}
