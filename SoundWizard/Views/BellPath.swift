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
    var strokeColor: Color = .white
    
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
                    .stroke(strokeColor.opacity(0.8), lineWidth: 2)
                
                separatorPath(size: geometry.size)
                    .stroke(Color.teal.opacity(0.2), lineWidth: 1)
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
        // Curve height
        let a = 2 * (filter.y - 0.5) * size.height / 2
        // Curve center x
        let b = size.width * filter.x
        // Curve width
        let c = size.width / filter.q / 6

        return -a * exp(-pow(x - b, 2) / (2 * pow(c, 2)))
    }
    
    private func gradient(for index: Int) -> Gradient {
        let color = self.color(for: index)
        return Gradient(stops: [
            Gradient.Stop(color: color, location: 0),
            Gradient.Stop(color: color.opacity(0.5), location: 0.5),
            Gradient.Stop(color: color, location: 1)
        ])
    }
    
    private func color(for index: Int) -> Color {
        switch index {
        case 0:
            return Color.teal
        case 1:
            return Color(red: 0.6, green: 0.3, blue: 0.8, opacity: 1)
        default:
            return Color(red: 0.8, green: 0.7, blue: 0.1)
        }
    }
}
