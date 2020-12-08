//
//  FrequencyGraph.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/7/20.
//

import SwiftUI

struct FrequencyGraph: View {
    
    let range: FrequencyRange
    let referenceFrequencies: [Frequency]
    
    private let labelWidth: CGFloat = 80
    
    var body: some View {
        GeometryReader { geometry in
            
            referenceLines(size: geometry.size)
                .stroke(Color.teal.opacity(0.5))
            
            referenceLabels(size: geometry.size)
            
        }
    }
    
    private func referenceLines(size: CGSize) -> Path {
        Path { path in
            for x in referenceFrequencies.map({ x(for: $0, width: size.width) }) {
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
            }
        }
    }
    
    private func referenceLabels(size: CGSize) -> some View {
        ForEach(referenceFrequencies, id: \.self) { freq in
            let leftX = x(for: freq, width: size.width) - labelWidth / 2
            Text(freq.shortString)
                .frame(width: labelWidth, height: 20, alignment: .center)
                .font(.monoSemiBold(10))
                .foregroundColor(Color(white: 0.6, opacity: 1))
                .offset(x: leftX, y: size.height)
        }
    }
    
    private func x(for freq: Frequency, width: CGFloat) -> CGFloat {
        return CGFloat(freq.percentage(in: range)) * width
    }
}

struct FrequencyGraph_Previews: PreviewProvider {
    static let range = BandFocus.all.range
    static let refs = BandFocus.all.referenceFrequencies
    
    static var previews: some View {
        FrequencyGraph(range: range, referenceFrequencies: refs)
            .frame(width: nil, height: 300, alignment: .center)
            .preferredColorScheme(.dark)
    }
}
