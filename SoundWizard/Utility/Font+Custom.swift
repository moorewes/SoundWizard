//
//  Font+Custom.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/18/20.
//

import SwiftUI

extension Font {
    
    static func mono(_ style: TextStyle, sizeModifier: CGFloat = 0) -> Font {
        let fontData = style.monoFontData
        return Font.custom(fontData.name, size: fontData.size + sizeModifier, relativeTo: style)
    }
    
    static func std(_ style: TextStyle, sizeModifier: CGFloat = 0) -> Font {
        let fontData = style.stdFontData
        return Font.custom(fontData.name, size: fontData.size + sizeModifier, relativeTo: style)
    }
    
}

extension UIFont {
    
    static func mono(_ style: Font.TextStyle, sizeModifier: CGFloat = 0) -> UIFont {
        let fontData = style.monoFontData
        return UIFont(name: fontData.name, size: fontData.size + sizeModifier)!
    }
    
    static func std(_ style: Font.TextStyle, sizeModifier: CGFloat = 0) -> UIFont {
        let fontData = style.stdFontData
        return UIFont(name: fontData.name, size: fontData.size + sizeModifier)!
    }
    
}

extension Font.TextStyle {
    
    var monoFontData: (name: String, size: CGFloat) {
        switch self {
        case .body:
            return ("FiraCode-Regular", 18)
        case .largeTitle:
            return ("FiraCode-Bold", 32)
        case .title:
            return ("FiraCode-Bold", 28)
        case .title2:
            return ("FiraCode-Bold", 24)
        case .title3:
            return ("FiraCode-Bold", 22)
        case .headline:
            return ("FiraCode-Bold", 18)
        case .subheadline:
            return ("FiraCode-Bold", 14)
        case .callout:
            return ("FiraCode-Bold", 15)
        case .footnote:
            return ("FiraCode-Bold", 12)
        case .caption:
            return ("FiraCode-Regular", 11)
        case .caption2:
            return ("FiraCode-SemiBold", 10)
        default:
            return ("FiraCode-Regular", 14)
        }
    }
    
    var stdFontData: (name: String, size: CGFloat) {
        switch self {
        case .body:
            return ("WorkSans-Regular", 18)
        case .largeTitle:
            return ("WorkSans-SemiBold", 32)
        case .title:
            return ("WorkSans-SemiBold", 28)
        case .title2:
            return ("WorkSans-SemiBold", 24)
        case .title3:
            return ("WorkSans-SemiBold", 22)
        case .headline:
            return ("WorkSans-SemiBold", 18)
        case .subheadline:
            return ("WorkSans-SemiBold", 14)
        case .callout:
            return ("WorkSans-SemiBold", 16)
        case .footnote:
            return ("WorkSans-Regular", 12)
        case .caption:
            return ("WorkSans-Regular", 11)
        case .caption2:
            return ("WorkSans-Regular", 10)
        default:
            return ("WorkSans-Regular", 14)
        }
    }
    
}


