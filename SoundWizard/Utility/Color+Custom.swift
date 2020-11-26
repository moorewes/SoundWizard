//
//  Color+Custom.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/25/20.
//

import SwiftUI

extension Color {
    
    static let teal = Color(UIColor.systemTeal)
    
    static let darkBackground = Color(white: 0.2, opacity: 1)
    
    static let extraDarkGray = Color(white: 0.08)
    
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
