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
