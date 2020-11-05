//
//  Extensions.swift
//  SoundWizard
//
//  Created by Wes Moore on 10/28/20.
//

import Foundation

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
