//
//  Color+Custom.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/25/20.
//

import SwiftUI

// TODO: Cleanup, rename to be more generic, make dynamic
extension Color {
    static let teal = Color(UIColor.systemTeal)
    
    static let primaryBackground = Color.init(hue: 0.62, saturation: 0.3, brightness: 0.18) //Color(white: 0.15, opacity: 1)
    
    static let secondaryBackground = Color.init(hue: 0.6, saturation: 0.3, brightness: 0.33) // Color(white: 0.3)
    
    static let extraDarkGray = Color(white: 0.08)
    
    static let darkGray = Color(white: 0.4)
    
    static let extraLightGray = Color(white: 0.9)
    
    static let lightGray = Color(white: 0.8)
    
    static let listRowBackground = Color(white: 0.3)
    
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
}
