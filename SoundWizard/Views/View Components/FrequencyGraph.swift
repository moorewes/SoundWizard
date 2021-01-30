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

    var body: some View {
        GeometryReader { geometry in
            referenceLines(size: geometry.size)
                .stroke(referenceLineColor)
            
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
        Group {
            ForEach(referenceFrequencies, id: \.self) { freq in
                let centerX = x(for: freq, width: size.width)// - labelWidth / 2
                Text(freq.shortString)
                    .font(.mono(.caption2))
                    .foregroundColor(referenceLabelTextColor)
                    .position(x: centerX, y: size.height + 10)
            }
        }
    }
    
    private func x(for freq: Frequency, width: CGFloat) -> CGFloat {
        CGFloat(freq.octavePercentage(in: range) ?? 0) * width
    }
    
    private let labelWidth: CGFloat = 80
    private let referenceLineColor = Color.teal.opacity(0.3)
    private let referenceLabelTextColor = Color(white: 0.6, opacity: 1)
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
