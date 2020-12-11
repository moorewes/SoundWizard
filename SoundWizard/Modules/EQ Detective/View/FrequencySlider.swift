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
    var timeBetweenTurns: Double { get }
    
}

struct FrequencySlider: View {
    
    private var data: FrequencySliderDataSource
    
    @Binding var frequency: Frequency
    
    private var octavesVisible: Float
            
    init(data: FrequencySliderDataSource, frequency: Binding<Frequency>) {
        self.data = data
        _frequency = frequency
        octavesVisible = AudioMath.octaves(in: data.frequencyRange)
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            let graphRect = graphFrame(size: geometry.size)
            
            FrequencyGraph(range: data.frequencyRange, referenceFrequencies: data.referenceFreqs)
                .padding(.vertical, graphVerticalPadding)
            
            sliderLabel(size: geometry.size)
                .position(sliderLabelPosition(in: geometry.size))
            
            
            errorShadedRect(size: geometry.size)
                .foregroundColor(Color.teal.opacity(0.2))
                .padding(.vertical, graphVerticalPadding)
                
                
            selectedLine(rect: graphRect)
                .stroke(Color.white, lineWidth: 2)

            solutionLine(rect: graphRect)

            Rectangle()
                .size(geometry.size)
                .foregroundColor(Color(white: 1, opacity: 0.001))
                .frequencyDragGesture(frequency: $frequency, range: data.frequencyRange)
        }
    
    }
    
    
    // MARK: - Sub views
    
    private func errorShadedRect(size: CGSize) -> some View {
        let x = sliderX(in: size)
        let width = size.width * CGFloat(data.octavesShaded / octavesVisible)
        
        return RoundedRectangle(cornerRadius: shadeCornerRadius)
            .frame(width: width, height: nil, alignment: .center)
            .position(x: x, y: size.height / 2 - 30)
            .animation(Animation.easeInOut.delay(data.timeBetweenTurns), value: width)
    }
    
    private func selectedLine(rect: CGRect) -> Path {
        
        Path { path in
            let x = sliderX(in: rect.size)
            path.move(to: CGPoint(x: x, y: rect.minY))
            path.addLine(to: CGPoint(x: x, y: rect.maxY))
        }
    }
    
    private func solutionLine(rect: CGRect) -> some View {
        VStack {
            if let solution = data.solutionFreq {
                Path { path in
                    let solutionX = x(for: solution, width: rect.width)
                    path.move(to: CGPoint(x: solutionX, y: rect.minY))
                    path.addLine(to: CGPoint(x: solutionX, y: rect.maxY))
                }
                .stroke(data.solutionLineColor, lineWidth: 2)
            }
        }
    }
    
    private func sliderLabel(size: CGSize) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text(frequency.decimalString)
                .font(.mono(.headline))
                .foregroundColor(Color.white)
            Text(" " + frequency.unitString)
                .font(.mono(.callout))
                .foregroundColor(Color.white)
        }
    }
    
    // MARK - Drawing Constants
    
    private let graphVerticalPadding: CGFloat = 30

    private let shadeCornerRadius: CGFloat = 10
    private let sliderLabelTopSpace: CGFloat = 5
    
    private var answerPercentage: CGFloat? {
        guard let solutionFreq = data.solutionFreq else { return nil }
        return percentage(for: solutionFreq)
    }
    
    private func graphFrame(size: CGSize) -> CGRect {
        return CGRect(x: 0,
               y: graphVerticalPadding,
               width: size.width,
               height: size.height - graphVerticalPadding * 2
        )
    }
    
    private func x(for freq: Frequency, width: CGFloat) -> CGFloat {
        return CGFloat(freq.percentage(in: data.frequencyRange)) * width
    }
    
    private func sliderX(in size: CGSize) -> CGFloat {
        return percentage(for: frequency) * size.width
    }
    
    private func percentage(for freq: Frequency) -> CGFloat {
        return CGFloat(freq.percentage(in: data.frequencyRange))
    }
    
    private func sliderLabelPosition(in size: CGSize) -> CGPoint {
        let x = sliderX(in: size)
        return CGPoint(x: x, y: sliderLabelTopSpace)
    }
    
}
//
//struct FrequencySlider_Previews: PreviewProvider {
//    static var game = EQDetectiveGame(level: EQDetectiveLevel.level(1)!, gameViewState: .constant(.inGame))
//
//    static var previews: some View {
//        ZStack {
//            Color.darkBackground.ignoresSafeArea()
//            FrequencySlider(data: game,
//                            frequency: .constant(1000))
//                .frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//        }
//        .background(Color.darkBackground)
//        .ignoresSafeArea()
//    }
//}
