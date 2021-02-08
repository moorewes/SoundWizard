//
//  BellPath.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/24/20.
//

import SwiftUI

struct BellPath: View {
    let filters: CGFilters
    var filled: Bool = true
    var strokeColor: Color = Design.strokeColor
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if filled {
                    ForEach(filters.data, id: \.self) { data in
                        fillPath(for: data, size: geometry.size)
                        .fill(
                            LinearGradient(gradient: gradient(for: data.index), startPoint: .top, endPoint: .bottom)
                        )
                        .blendMode(BlendMode.lighten)
                    }
                }
                
                linePath(size: geometry.size)
                    .stroke(strokeColor, lineWidth: Design.curveLineWidth)
                
                separatorPath(size: geometry.size)
                    .stroke(Design.bandSeparatorColor, lineWidth: Design.bandSeparatorWidth)
            }
        }
    }
    
    func separatorPath(size: CGSize) -> Path {
        Path { path in
            for i in 1..<filters.data.count {
                let x = CGFloat(i) / CGFloat(filters.data.count) * size.width
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
            }
        }
    }
    
    func linePath(size: CGSize) -> Path {
        Path { path in
            path.move(to: linePoint(x: 0, size: size))
            for x in stride(from: 0, through: size.width, by: 0.5) {
                path.addLine(to: linePoint(x: x, size: size))
            }
        }
    }
    
    func fillPath(for filter: CGFilterData, size: CGSize) -> Path {
        Path { path in
            let startY = size.height / 2
            let start = CGPoint(x: 0, y: startY + yOffset(for: filter, x: 0, size: size))
            path.move(to: start)
            for x in stride(from: 0.5, through: size.width, by: 0.5) {
                let y = startY + yOffset(for: filter, x: x, size: size)
                path.addLine(to: CGPoint(x: x, y: y))
            }
            path.addLine(to: CGPoint(x: size.width, y: startY))
            path.addLine(to: CGPoint(x: 0, y: startY))
            path.closeSubpath()
        }
    }
    
    func linePoint(x: CGFloat, size: CGSize) -> CGPoint {
        let y = filters.data.reduce(size.height / 2) { $0 + yOffset(for: $1, x: x, size: size) }
        return CGPoint(x: x, y: y)
    }
    
    func yOffset(for filter: CGFilterData, x: CGFloat, size: CGSize) -> CGFloat {
        let a = 2 * (filter.y - 0.5) * size.height / 2  // Curve height
        let b = size.width * filter.x                   // Curve center x
        let c = size.width / filter.q / 6               // Curve width

        return -a * exp(-pow(x - b, 2) / (2 * pow(c, 2)))
    }
    
    private func gradient(for index: Int) -> Gradient {
        let color = Design.fillColor(index: index)
        return Gradient(stops: [
            Gradient.Stop(color: color, location: 0),
            Gradient.Stop(color: color.opacity(0.5), location: 0.5),
            Gradient.Stop(color: color, location: 1)
        ])
    }
}

extension BellPath {
    enum Design {
        static let strokeColor = Color.white
        static let bandSeparatorColor = Color.teal.opacity(0.2)
        
        static let curveLineWidth: CGFloat = 2.0
        static let bandSeparatorWidth: CGFloat = 1.0
        
        static func fillColor(index: Int) -> Color {
            Color.eqBandFillColor(index: index)
        }
    }
}
