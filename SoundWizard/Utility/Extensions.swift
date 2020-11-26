//
//  Extensions.swift
//  SoundWizard
//
//  Created by Wes Moore on 10/28/20.
//

import SwiftUI

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

extension Float {
    var uiString: String {
        let isInt = self - Float(Int(self)) == 0
        return isInt ? "\(Int(self))" : String(format: "%.1f", self)
    }
    
    
}



extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}
