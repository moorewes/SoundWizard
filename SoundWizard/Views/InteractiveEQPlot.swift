//
//  PeakingFilterGainSlider.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/24/20.
//

import SwiftUI

struct InteractiveEQPlot: View {
    @Binding var filters: [EQBellFilterData]
    var canAdjustGain = true
    var canAdjustFrequency = true
    var frequencyRange: FrequencyRange {
        filters.frequencyRange
    }

    var body: some View {
        ZStack {
            BellPath(filters: filterCGData)
                .zIndex(0)
            
            HStack(spacing: 0) {
                ForEach(filters.indices, id: \.self) { index in
                    DragZone(filter: $filters[index],
                             frequencyRange: frequencyRange,
                             xRange: xRange(for: index),
                             yRange: yRange(for: index))
                }
            }
        }
    }
    
    private var filterCGData: [CGFilterData] {
        filters.map { CGFilterData(data: $0) }
    }
    
    private func xRange(for index: Int) -> ClosedRange<CGFloat> {
        let filter = filters[index]
        
        guard canAdjustFrequency else {
            let value = CGFloat(filter.x(in: frequencyRange))
            return value...value
        }
        
        let minF = filter.frequencyRange.lowerBound
        let maxF = filter.frequencyRange.upperBound
        let minX = CGFloat(minF.percentage(in: frequencyRange))
        let maxX = CGFloat(maxF.percentage(in: frequencyRange))
        return minX...maxX
    }
    
    private func yRange(for index: Int) -> ClosedRange<CGFloat> {
        let filter = filters[index]
        guard canAdjustGain else {
            let value = CGFloat(filter.y(in: filter.dBGainRange))
            return value...value
        }
        return 0...1
    }
}

extension InteractiveEQPlot {
    struct DragZone: View {
        @Binding var filter: EQBellFilterData
        let frequencyRange: FrequencyRange
        let xRange: ClosedRange<CGFloat>
        let yRange: ClosedRange<CGFloat>
        
        @State private var dragStart: CGFilterData?
        
        var body: some View {
            GeometryReader { geometry in
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.01))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                handleDragChange(translation: value.translation, size: geometry.size)
                            }
                            .onEnded { _ in dragStart = nil }
                    )
            }
           
        }
        
        func handleDragChange(translation: CGSize, size: CGSize) {
            if dragStart == nil {
                dragStart = CGFilterData(data: filter)
            }
            let xOffset = translation.width / size.width
            let yOffset = -translation.height / size.height
            let x = (dragStart!.x + xOffset).clamped(to: xRange)
            let y = (dragStart!.y + yOffset).clamped(to: yRange)
            print(x)
            filter.frequency = AudioMath.frequency(percent: Float(x), in: frequencyRange)
            filter.gain.dB = filter.dBGainRange.upperBound * Float(y - 0.5) * 2
        }
    }
}

struct CGFilterData: Hashable {
    var x: CGFloat { didSet { x.clamp(to: xRange) } }
    var y: CGFloat { didSet { y.clamp(to: yRange) } }
    var q: CGFloat
    
    var xRange: ClosedRange<CGFloat> = 0...1
    var yRange: ClosedRange<CGFloat> = 0...1
    
    init(data: EQBellFilterData) {
        x = CGFloat(data.frequency.percentage(in: data.frequencyRange))
        y = CGFloat(data.gain.dB / data.dBGainRange.upperBound) / 2 + 0.5
        q = CGFloat(data.q)
    }
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
}

private extension EQBellFilterData {
    func x(in range: FrequencyRange) -> CGFloat {
        CGFloat(frequency.percentage(in: range))
    }
    
    func y(in range: ClosedRange<Float>) -> CGFloat {
        CGFloat(gain.dB / range.upperBound) / 2 + 0.5
    }
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
