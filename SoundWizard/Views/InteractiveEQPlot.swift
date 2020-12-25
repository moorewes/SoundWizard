//
//  PeakingFilterGainSlider.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/24/20.
//

import SwiftUI

private extension EQBellFilterData {
    func x(in range: FrequencyRange) -> CGFloat {
        CGFloat(frequency.percentage(in: range))
    }
    func y(in range: ClosedRange<Float>) -> CGFloat {
        CGFloat(gain.dB / range.upperBound) / 2 + 0.5
    }
}

struct InteractiveEQPlot: View {
    @Binding var filters: [EQBellFilterData]
    var canAdjustGain = true
    var canAdjustFrequency = true
    
    var body: some View {
        ZStack {
            BellPath(filters: filterCGData)
                .zIndex(0)
            
            HStack(spacing: 0) {
                ForEach(filters.indices, id: \.self) { index in
                    DragZone(filter: $filters[index],
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
            let value = CGFloat(filter.x(in: filter.frequencyRange))
            return value...value
        }
        let span = 1 / CGFloat(filters.count)
        let start = span * CGFloat(index)
        return start...(start + span)
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
            
            filter.frequency = AudioMath.frequency(percent: Float(x), in: filter.frequencyRange)
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
