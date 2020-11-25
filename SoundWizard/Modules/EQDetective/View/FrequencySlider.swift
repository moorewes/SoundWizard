//
//  FrequencySlider.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/12/20.
//

import SwiftUI

struct FrequencySlider: View {
    
    @ObservedObject var game: EQDetectiveGame
    @GestureState private var dragPercentage: CGFloat = 0.0
        
    var body: some View {
        GeometryReader { geometry in
            
            let frame = geometry.frame(in: .local)

            referenceLines(frame: frame)
                .stroke(Color.teal.opacity(0.5))
            
            referenceLabels(size: geometry.size)
            
            shadedRect(size: geometry.size)
                .foregroundColor(Color.teal.opacity(0.15))
            
            selectedLine(size: geometry.size)
                .stroke(Color.white, lineWidth: 2)
            
            solutionLine(size: geometry.size)

            Text(currentFreq.freqDecimalString)
                .frame(width: labelWidth, height: 20, alignment: .center)
                .offset(x: percentage * geometry.size.width - labelWidth / 2, y: 0)
                .font(.monoSemiBold(18))
                .foregroundColor(Color.white)
            
            Rectangle()
                .size(geometry.frame(in: .local).size)
                .foregroundColor(Color(white: 1, opacity: 0.001))
                .gesture(dragGesture(width: geometry.size.width))
        }
        
    }
  
    private func referenceLines(frame: CGRect) -> Path {
        Path { path in
            for x in lineXPositions(width: frame.width) {
                path.move(to: CGPoint(x: x, y: topSpace))
                path.addLine(to: CGPoint(x: x, y: frame.maxY - bottomSpace))
            }
        }
    }
    
    private func referenceLabels(size: CGSize) -> some View {
        ForEach(graphLineFreqs, id: \.self) { freq in
            let percentage = CGFloat(freq.octave / octaveCount)
            let leftX = percentage * size.width - labelWidth / 2
            Text(freq.freqIntString)
                .frame(width: labelWidth, height: 20, alignment: .center)
                .font(.monoSemiBold(10))
                .foregroundColor(Color(white: 0.6, opacity: 1))
                .offset(x: leftX, y: size.height - bottomSpace)
        }
    }
    
    private func shadedRect(size: CGSize) -> Path {
        Path { path in
            let width = size.width * CGFloat(2 * octavesShaded / octaveCount)
            let startX = percentage * size.width - width / 2
            let height = size.height - bottomSpace - topSpace
            let rect = CGRect(x: startX, y: topSpace, width: width, height: height)
            path.addRoundedRect(in: rect, cornerSize: CGSize(width: 20, height: 20))
        }
    }
    
    private func selectedLine(size: CGSize) -> Path {
        Path { path in
            let x = percentage * size.width
            path.move(to: CGPoint(x: x, y: topSpace))
            path.addLine(to: CGPoint(x: x, y: size.height - bottomSpace))
        }
    }
    
    @ViewBuilder
    private func solutionLine(size: CGSize) -> some View {
        if let answerPercentage = self.answerPercentage,
              let color = self.answerLineColor {
            Path { path in
                let x = answerPercentage * size.width
                path.move(to: CGPoint(x: x, y: topSpace))
                path.addLine(to: CGPoint(x: x, y: size.height - bottomSpace))
            }
            .stroke(color, lineWidth: 2)
        } else {
            EmptyView()
        }
    }
    
    // TODO: Final value tends to be different than last updated causing a shift when releasing finger
    private func dragGesture(width: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($dragPercentage) { (newValue, dragPercentage, _) in
                dragPercentage = newValue.translation.width / width
                print("updated drag: \(newValue.translation.width)")
            }
            .onChanged({ (value) in
                print("changed drag: \(value.translation.width)")
            })
            .onEnded { finalValue in
                let percentage = self.percentage + finalValue.translation.width / width
                let octave = Float(percentage.clamped(to: percentageRange)) * octaveCount
                game.freqSliderChanged(to: octave.frequency.rounded())
                print("committed drag: \(finalValue.translation.width)")
            }
    }
    
    // MARK - Drawing Constants
    
    private let graphLineFreqs: [Float] = [31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
    private let topSpace: CGFloat = 30
    private let bottomSpace: CGFloat = 30
    private let labelWidth: CGFloat = 100
    
    // MARK: - Computed
    
    private var octavesShaded: Float { game.level.octaveErrorRange }
    private var octaveCount: Float { game.level.octavesVisible }
    private var percentageRange: ClosedRange<CGFloat> { game.freqSliderRange }
    private var answerOctave: Float? { game.currentTurn?.solution.octave }
    
    private var answerLineColor: Color? {
        guard let success = game.currentTurn?.score?.successLevel else {
            return Color.clear
        }
        return Color.successLevelColor(success)
    }
    
    private var currentFreq: Float {
        if dragPercentage == 0 {
            return game.selectedFreq
        } else {
            let octave = Float(percentage) * octaveCount
            return octave.frequency.rounded()
        }
        
    }
    
    private var percentage: CGFloat {
        let result = game.freqSliderValue + dragPercentage
        //print("drew line at pct: \(result.clamped(to: percentageRange))")
        return result.clamped(to: percentageRange)
    }
    
    private var answerPercentage: CGFloat? {
        guard let octave = answerOctave else { return nil }
        return CGFloat(octave / octaveCount)
    }
        
    private func x(for freq: Float, width: CGFloat) -> CGFloat {
        return width * CGFloat(freq.octave) / CGFloat(graphLineFreqs.count)
    }
    
    private func lineXPositions(width: CGFloat) -> [CGFloat] {
        return graphLineFreqs.map { x(for: $0, width: width) }
    }
    
}
