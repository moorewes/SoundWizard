//
//  FSlider.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/30/20.
//

import SwiftUI

protocol FrequencySliderDataSource {
    
    var frequencyRange: FrequencyRange { get }
    var octavesShaded: Float { get }
    var solutionFreq: Frequency? { get }
    var solutionLineColor: Color { get }
    var referenceFreqs: [Frequency] { get }
    
}

struct FrequencySlider: View {
    
    var data: FrequencySliderDataSource
    
    @Binding var frequency: Frequency
    @GestureState private var dragPercentage: CGFloat = 0.0
    
    var dragState = DragState()
    
    init(data: FrequencySliderDataSource, frequency: Binding<Frequency>) {
        self.data = data
        _frequency = frequency
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            referenceLines(size: geometry.size)
                .stroke(Color.teal.opacity(0.5))

            referenceLabels(size: geometry.size)

            shadedRect(size: geometry.size)
                .foregroundColor(Color.teal.opacity(0.15))

            selectedLine(size: geometry.size)
                .stroke(Color.white, lineWidth: 2)

            solutionLine(size: geometry.size)
            
            sliderLabel(size: geometry.size)
                .position(sliderLabelPosition(in: geometry.size))

            Rectangle()
                .size(geometry.size)
                .foregroundColor(Color(white: 1, opacity: 0.001))
                .gesture(dragGesture(width: geometry.size.width))
        }
        
    }
    
    // MARK: - Sub views
  
    private func referenceLines(size: CGSize) -> Path {
        Path { path in
            for x in data.referenceFreqs.map({ x(for: $0, width: size.width) }) {
                path.move(to: CGPoint(x: x, y: topSpace))
                path.addLine(to: CGPoint(x: x, y: size.height - bottomSpace))
            }
        }
    }
    
    private func referenceLabels(size: CGSize) -> some View {
        ForEach(data.referenceFreqs, id: \.self) { freq in
            let leftX = x(for: freq, width: size.width) - labelWidth / 2
            Text(freq.shortString)
                .frame(width: labelWidth, height: 20, alignment: .center)
                .font(.monoSemiBold(10))
                .foregroundColor(Color(white: 0.6, opacity: 1))
                .offset(x: leftX, y: size.height - bottomSpace)
        }
    }
    
    private func shadedRect(size: CGSize) -> Path {
        Path { path in
            let shadeWidth = size.width * CGFloat(data.octavesShaded / octavesVisible)
            let startX = sliderX(in: size) - shadeWidth / 2
            let height = size.height - bottomSpace - topSpace
            let rect = CGRect(x: startX, y: topSpace, width: shadeWidth, height: height)
            path.addRoundedRect(in: rect, cornerSize: shadeCornerSize)
        }
    }
    
    private func selectedLine(size: CGSize) -> Path {
        Path { path in
            let x = sliderX(in: size)
            path.move(to: CGPoint(x: x, y: topSpace))
            path.addLine(to: CGPoint(x: x, y: size.height - bottomSpace))
        }
    }
    
    private func solutionLine(size: CGSize) -> some View {
        VStack {
            if let solution = data.solutionFreq {
                Path { path in
                    let solutionX = x(for: solution, width: size.width)
                    path.move(to: CGPoint(x: solutionX, y: topSpace))
                    path.addLine(to: CGPoint(x: solutionX, y: size.height - bottomSpace))
                }
                .stroke(data.solutionLineColor, lineWidth: 2)
            }
        }
    }
    
    private func dragGesture(width: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($dragPercentage) { (newValue, dragPercentage, _) in
                dragPercentage = newValue.translation.width / width
                dragState.dragEndPercentage = dragPercentage
            }
            .onEnded { finalValue in
                let percentage = self.sliderPercentage + dragState.dragEndPercentage
                frequency = frequency(for: percentage.clamped(to: 0...1))
            }
    }
    
    private func sliderLabel(size: CGSize) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text(sliderFrequency.decimalString)
                .font(.monoSemiBold(18))
                .foregroundColor(Color.white)
            Text(" " + sliderFrequency.unitString)
                .font(.monoSemiBold(15))
                .foregroundColor(Color.white)
        }
    }
    
    // MARK - Drawing Constants
    
    private let topSpace: CGFloat = 30
    private let bottomSpace: CGFloat = 30
    private let labelWidth: CGFloat = 80
    private let shadeCornerSize = CGSize(width: 20, height: 20)
    private let sliderLabelTopSpace: CGFloat = 5
    
    private var sliderFrequency: Frequency {
        if dragPercentage == 0 {
            return frequency
        } else {
            return frequency(for: sliderPercentage)
        }
    }
    
    private var sliderPercentage: CGFloat {
        let result = percentage(for: frequency) + dragPercentage
        return result.clamped(to: 0...1)
    }
    
    private var answerPercentage: CGFloat? {
        guard let solutionFreq = data.solutionFreq else { return nil }
        return percentage(for: solutionFreq)
    }
    
    private var octavesVisible: Float {
        AudioMath.octaves(in: data.frequencyRange)
    }
    
    private func x(for freq: Frequency, width: CGFloat) -> CGFloat {
        return CGFloat(freq.percentage(in: data.frequencyRange)) * width
    }
    
    private func sliderX(in size: CGSize) -> CGFloat {
        return sliderPercentage * size.width
    }
    
    private func percentage(for freq: Frequency) -> CGFloat {
        return CGFloat(freq.percentage(in: data.frequencyRange))
    }
    
    private func sliderLabelPosition(in size: CGSize) -> CGPoint {
        let x = sliderX(in: size)
        return CGPoint(x: x, y: sliderLabelTopSpace)
    }
    
    private func frequency(for percentage: CGFloat) -> Float {
        let octave = Float(percentage) * octavesVisible
        return AudioMath.freq(fromOctave: octave, baseOctaveFreq: data.frequencyRange.lowerBound, rounded: true)
    }
    
    // MARK: - Types
    
    /// Used as a workaround for deciding on the final value for the drag gesture.
    /// Using the final value from .onEnded results in a slight jump that is probably
    /// caused by the user lifting their finger. This object stores the last drag value
    /// received by .updating to be used for the .onEnded block.
    class DragState {
        var dragEndPercentage: CGFloat = 0.0
    }
    
}

//struct FSlider_Previews: PreviewProvider {
//    static var game = EQDetectiveGame(level: EQDetectiveLevel.level(1)!, viewState: .constant(.inGame))
//
//    static var previews: some View {
//        ZStack {
//            Color.darkBackground.ignoresSafeArea()
//            FSlider(data: game,
//                    frequency: game.$selectedFreq)
//                .frame(width: nil, height: 500, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//        }
//        .background(Color.darkBackground)
//        .ignoresSafeArea()
//    }
//}
