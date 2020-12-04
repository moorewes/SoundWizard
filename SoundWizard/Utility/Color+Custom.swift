//
//  Color+Custom.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/25/20.
//

import SwiftUI

extension Color {
    
    static let teal = Color(UIColor.systemTeal)
    
    static let darkBackground = Color(white: 0.15, opacity: 1)
    
    static let extraDarkGray = Color(white: 0.08)
    
    static let extraLightGray = Color(white: 0.9)
    
    static let lightGray = Color(white: 0.8)
    
    static func successLevelColor(_ successLevel: ScoreSuccessLevel) -> Color {
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
