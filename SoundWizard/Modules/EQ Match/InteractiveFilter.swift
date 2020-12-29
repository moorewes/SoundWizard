//
//  InteractiveFilter.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/7/20.
//

//
//  FSlider.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/30/20.
//

import SwiftUI

protocol InteractiveFilterDataSource {
    var frequencyRange: FrequencyRange { get }
    var octavesShaded: Double { get }
    var solutionFreq: Frequency? { get }
    var solutionGain: Double { get }
    var solutionLineColor: Color { get }
    var referenceFreqs: [Frequency] { get }
    var timeBetweenTurns: Double { get }
    var filterQ: Double { get }
}

struct InteractiveFilter: View {
    private var data: InteractiveFilterDataSource
    
    @Binding var frequency: Frequency
    @Binding var gain: Double
    @GestureState private var dragPercentage: (x: CGFloat, y: CGFloat) = (0.0, 0.0)
        
    private var dragState = DragState()
    
    init(data: InteractiveFilterDataSource, frequency: Binding<Frequency>, gain: Binding<Double>) {
        self.data = data
        _frequency = frequency
        _gain = gain
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            sliderLabel(size: geometry.size)
                .position(sliderLabelPosition(in: geometry.size))
            
            
            referenceLines(size: geometry.size)
                .stroke(Color.teal.opacity(0.5))
            
            
            errorShadedRect(size: geometry.size)
                .foregroundColor(Color.teal.opacity(0.2))
                
                
            selectedLine(size: geometry.size)
                .stroke(Color.yellow, lineWidth: 2)

            solutionLine(size: geometry.size)

            referenceLabels(size: geometry.size)

            Rectangle()
                .size(geometry.size)
                .foregroundColor(Color(white: 1, opacity: 0.001))
                .gesture(dragGesture(size: geometry.size))
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
                .font(.mono(.caption2))
                .foregroundColor(Color(white: 0.6, opacity: 1))
                .offset(x: leftX, y: size.height - bottomSpace)
        }
    }
    
    private func errorShadedRect(size: CGSize) -> some View {
        let x = sliderX(in: size)
        let y = size.height / 2 + topSpace - bottomSpace
        let width = size.width * CGFloat(data.octavesShaded / octavesVisible)
        let height = size.height - topSpace - bottomSpace
        
        return RoundedRectangle(cornerRadius: shadeCornerRadius)
            .frame(width: width, height: height, alignment: .center)
            .position(x: x, y: y)
            .animation(Animation.easeInOut.delay(data.timeBetweenTurns), value: width)
    }
    
    private func selectedLine(size: CGSize) -> Path {
        Path { path in
            let start = bellStart(size: size)
            let endX = size.width
            path.move(to: start)
            for i in stride(from: start.x, through: endX, by: 1) {
                let i = CGFloat(i)
                let y = bellY(x: i, size: size)
                path.addLine(to: CGPoint(x: i, y: y))
            }
//            let x = sliderX(in: size)
//            path.move(to: CGPoint(x: x, y: topSpace))
//            path.addLine(to: CGPoint(x: x, y: size.height - bottomSpace))
        }
    }
    
    private func bellY(x: CGFloat, size: CGSize) -> CGFloat {
        let a = CGFloat(gain(for: gainPercentage)) * 15
        let b = size.width * sliderPercentage
        let c = size.width / (3 * CGFloat(data.filterQ))
        let startY = bellStart(size: size).y
        return startY - a * exp(-pow(x - b, 2) / (2 * pow(c, 2)))
    }
    
    private func bellStart(size: CGSize) -> CGPoint {
        return CGPoint(x: 0, y: size.height / 2)
    }
    
    private func gain(for percentage: CGFloat) -> Double {
        return  (Double(percentage) - 0.5) * dBRange
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
    
    private func dragGesture(size: CGSize) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($dragPercentage) { (newValue, dragPercentage, _) in
                dragPercentage.x = newValue.translation.width / size.width
                dragState.dragXEndPercentage = dragPercentage.x
                dragState.dragYEndPercentage = dragPercentage.y
                dragPercentage.y = -newValue.translation.height / size.height
            }
            .onEnded { finalValue in
                let percentage = self.sliderPercentage + dragState.dragXEndPercentage
                frequency = frequency(for: percentage.clamped(to: 0...1))
                let gainPercentage = self.gainPercentage + dragState.dragYEndPercentage
                print(dragState.dragYEndPercentage)
                gain = gain(for: gainPercentage)
                print("end gesture gain: \(gain)")
            }
    }
    
    private func sliderLabel(size: CGSize) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text(sliderFrequency.decimalString)
                .font(.mono(.subheadline))
                .foregroundColor(Color.white)
            Text(" " + sliderFrequency.unitString)
                .font(.mono(.subheadline))
                .foregroundColor(Color.white)
        }
    }
    
    // MARK - Drawing Constants
    
    private let topSpace: CGFloat = 30
    private let bottomSpace: CGFloat = 30
    private let labelWidth: CGFloat = 80
    private let shadeCornerRadius: CGFloat = 10
    private let sliderLabelTopSpace: CGFloat = 5
    private let dBRange: Double = 10
    
    private var sliderFrequency: Frequency {
        if dragPercentage.x == 0 {
            return frequency
        } else {
            return frequency(for: sliderPercentage)
        }
    }
    
    private var sliderPercentage: CGFloat {
        let result = percentage(for: frequency) + dragPercentage.x
        return result.clamped(to: 0...1)
    }
    
    private var gainPercentage: CGFloat {
        let result = gainPercentage(gain) + dragPercentage.y
        return result.clamped(to: 0...1)
    }
    
    private var answerPercentage: CGFloat? {
        guard let solutionFreq = data.solutionFreq else { return nil }
        return percentage(for: solutionFreq)
    }
    
    private var octavesVisible: Double {
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
    
    private func gainPercentage(_ gain: Double) -> CGFloat {
        return CGFloat(0.5 + gain / dBRange) // perc - 0.5 * dbRange
    }
    
    private func sliderLabelPosition(in size: CGSize) -> CGPoint {
        let x = sliderX(in: size)
        return CGPoint(x: x, y: sliderLabelTopSpace)
    }
    
    private func frequency(for percentage: CGFloat) -> Double {
        let octave = Double(percentage) * octavesVisible
        return AudioMath.freq(fromOctave: octave, baseOctaveFreq: data.frequencyRange.lowerBound, rounded: true)
    }
    
    // MARK: - Types
    
    /// Used as a workaround for deciding on the final value for the drag gesture.
    /// Using the final value from .onEnded results in a slight jump that is probably
    /// caused by the user lifting their finger. This object stores the last drag value
    /// received by .updating to be used for the .onEnded block.
    class DragState {
        var dragXEndPercentage: CGFloat = 0.0
        var dragYEndPercentage: CGFloat = 0.0
    }
    
}

//struct InteractiveFilter_Previews: PreviewProvider {
//    //static var game = EQMatchGame(level: EQMatchLevel.levels.first!, gameViewState: .constant(.inGame))
//
//    static var previews: some View {
//        InteractiveFilter(data: game, frequency: .constant(1000), gain: .constant(1))
//            .preferredColorScheme(.dark)
//            .frame(width: 330, height: 300, alignment: .center)
//    }
//}
