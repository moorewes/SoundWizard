//
//  Color+Custom.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/25/20.
//

import SwiftUI

extension Gradient {
    static let background = LinearGradient(
        gradient: Gradient(colors: [
            Color.ocean,
            Color.violet
        ]),
        startPoint: .top, endPoint: .bottom
    )
}

extension Color {
    static var swAccentColor: Color { teal }
    
    static let ocean = Color(hue: 0.54, saturation: 0.8, brightness: 0.2)
    static let teal = Color(UIColor.systemTeal)
    static let purple = Color(red: 0.6, green: 0.3, blue: 0.8, opacity: 1)
    static let violet = Color(hue: 0.75, saturation: 0.8, brightness: 0.2)
    static let darkViolet = Color(hue: 0.75, saturation: 0.8, brightness: 0.1)
    static let yellow = Color(red: 0.8, green: 0.7, blue: 0.1)
    
    static let primaryBackground = Color(hue: 0.54, saturation: 0.8, brightness: 0.2)
    static let secondaryBackground = Color.init(hue: 0.6, saturation: 0.5, brightness: 0.33)
    static let tertiaryBackground = Color.init(hue: 0.6, saturation: 0.5, brightness: 0.8)
    static let listRowBackground = Color(white: 0.3)
    
    static let extraDarkGray = Color(white: 0.05)
    static let darkGray = Color(white: 0.4)
    static let extraLightGray = Color(white: 0.9)
    static let lightGray = Color(white: 0.8)
        
    static func successLevelColor(_ successLevel: ScoreSuccess) -> Color {
        switch successLevel {
        case .failed, .justMissed:
            return Color.red
        case .fair:
            return Color.yellow
        case .great, .perfect:
            return Color.green
        }
    }
    
    static func eqBandFillColor(index: Int) -> Color {
        guard index >= 0 else { return eqBandFillColors[0] }
        
        return eqBandFillColors[safe: index] ?? eqBandFillColor(index: index - eqBandFillColors.count)
    }
    
    private static let eqBandFillColors = [
        Color.teal,
        Color.purple,
        Color.yellow,
        Color.green
    ]
}
