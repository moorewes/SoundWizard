//
//  FrequencyPickerView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/12/20.
//

import SwiftUI

struct FrequencyPickerView: View {
    
    @Binding var percentage: CGFloat
    @Binding var octavesShaded: Float
    @Binding var octaveCount: Float
    var answerOctave: Float?
    var answerLineColor: Color?
    
    @State var lastTranslation: CGFloat = 0.0
    
    var freq: Float {
        let octave = Float(percentage) * octaveCount
        return AudioCalculator.freq(fromOctave: octave)
    }
    
    var answerPercentage: CGFloat? {
        guard let octave = answerOctave else { return nil }
        return CGFloat(octave / octaveCount)
    }

    var graphLineFreqs: [Float] = [31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
    var graphLineOctaves: [Float] {
        graphLineFreqs.map { AudioCalculator.octave(fromFreq: $0) }
    }
    var topSpace: CGFloat = 30
    var bottomSpace: CGFloat = 30
    var labelWidth: CGFloat = 100
        
    var body: some View {
        GeometryReader { geometry in

            // Graph Lines
            Path { path in
                let frame = geometry.frame(in: .local)
                for x in lineXPositions(width: frame.width) {
                    path.move(to: CGPoint(x: x, y: topSpace))
                    path.addLine(to: CGPoint(x: x, y: frame.maxY - bottomSpace))
                }
            }
                .stroke(Color.teal.opacity(0.5))
            
            // Graph Line Labels
            ForEach(graphLineFreqs, id: \.self) { freq in
                let octave = AudioCalculator.octave(fromFreq: freq)
                let percentage = CGFloat(octave / octaveCount)
                let leftX = percentage * geometry.size.width - labelWidth / 2
                Text(freq.freqIntString)
                    .frame(width: labelWidth, height: 20, alignment: .center)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(Color(white: 0.6, opacity: 1))
                    .offset(x: leftX, y: geometry.frame(in: .local).height - bottomSpace)
            }
            
            // Shaded area
            Path { path in
                let width = geometry.size.width * CGFloat(2 * octavesShaded / octaveCount)
                let leftX = percentage * geometry.size.width - width / 2
                let rect = CGRect(x: leftX, y: topSpace, width: width, height: geometry.size.height - bottomSpace - topSpace)
                path.addRoundedRect(in: rect, cornerSize: CGSize(width: 20, height: 20))
            }
            .foregroundColor(Color.teal.opacity(0.15))
            
            // Selected Line
            Path { path in
                let x = percentage * geometry.size.width
                path.move(to: CGPoint(x: x, y: topSpace))
                path.addLine(to: CGPoint(x: x, y: geometry.size.height - bottomSpace))
                
            }
                .stroke(Color.white, lineWidth: 2)
            
            // Answer Line
            if let answerPercentage = self.answerPercentage,
               let color = self.answerLineColor {
                Path { path in
                    let x = answerPercentage * geometry.size.width
                    path.move(to: CGPoint(x: x, y: topSpace))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height - bottomSpace))
                    
                }
                    .stroke(color, lineWidth: 2)
            }
            
            
            // Selected Freq Label
            Text(freq.freqDecimalString)
                .frame(width: labelWidth, height: 20, alignment: .center)
                .offset(x: percentage * geometry.size.width - labelWidth / 2, y: 0)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.white)
            
            Rectangle()
                .size(geometry.frame(in: .local).size)
                .foregroundColor(Color(white: 1, opacity: 0.001))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { (value) in
                            let translation = value.translation.width - lastTranslation
                            let offset = translation / geometry.size.width
                            percentage += offset
                            lastTranslation = value.translation.width
                        }
                        .onEnded { _ in
                            lastTranslation = 0
                        }
                )
        }
        
    }
    
    func x(for freq: Float, width: CGFloat) -> CGFloat {
        let count = graphLineFreqs.count
        let octave = AudioCalculator.octave(fromFreq: freq)
        return width * CGFloat(octave) / CGFloat(count)
    }
    
    func lineXPositions(width: CGFloat) -> [CGFloat] {
        return graphLineFreqs.map { x(for: $0, width: width) }
    }
    
}
