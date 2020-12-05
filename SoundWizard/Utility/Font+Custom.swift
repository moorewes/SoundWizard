//
//  Font+Custom.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/18/20.
//

import SwiftUI

extension Font {
    
    static func monoBold(_ size: CGFloat) -> Font {
        return Font.custom("FiraCode-Bold", size: size)
    }
    
    static func monoSemiBold(_ size: CGFloat) -> Font {
        return Font.custom("FiraCode-SemiBold", size: size)
    }
    
    static func monoMedium(_ size: CGFloat) -> Font {
        return Font.custom("FiraCode-Medium", size: size)
    }
    
    static func monoRegular(_ size: CGFloat) -> Font {
        return Font.custom("FiraCode-Regular", size: size)
    }
    
    static func stdRegular(_ size: CGFloat) -> Font {
        return Font.custom("WorkSans-Regular", size: size)
    }
    
    static func stdSemiBold(_ size: CGFloat) -> Font {
        return Font.custom("WorkSans-SemiBold", size: size)
    }
    
}

extension UIFont {
    static func monoBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "FiraCode-Bold", size: size)!
    }
    
    static func monoSemiBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "FiraCode-SemiBold", size: size)!
    }
    
    static func monoMedium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "FiraCode-Medium", size: size)!
    }
    
    static func monoRegular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "FiraCode-Regular", size: size)!
    }
}
