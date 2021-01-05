//
//  Extensions.swift
//  SoundWizard
//
//  Created by Wes Moore on 10/28/20.
//

import SwiftUI

extension UserDefaults {
    func optionalBool(forKey defaultsName: String) -> Bool? {
        if let value = value(forKey: defaultsName) {
            return value as? Bool
        } else {
            return nil
        }
    }
}

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        return min(max(self, range.lowerBound), range.upperBound)
    }
    mutating func clamp(to range: ClosedRange<Self>) {
        self = self.clamped(to: range)
    }
}

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Double {
    var uiString: String {
        let isInt = self - Double(Int(self)) == 0
        return isInt ? "\(Int(self))" : String(format: "%.1f", self)
    }    
}

extension Double {
    init(percent: Double, in range: ClosedRange<Double>) {
        let span = range.upperBound - range.lowerBound
        let distanceFromLowerBound = span * percent
        self = range.lowerBound + distanceFromLowerBound
    }
    
    func percentage(in range: ClosedRange<Double>) -> Double? {
        guard range.contains(self) else { return nil }

        let distance = range.upperBound - range.lowerBound
        guard distance != 0 else { return nil }
        
        let distanceFromLowerBound = self - range.lowerBound
        return distanceFromLowerBound / distance
    }
    
    static func randomInt(in range: ClosedRange<Double>, excluding exclusion: Int? = nil) -> Double {
        let range = Int(range.lowerBound.rounded(.up))...Int(range.upperBound.rounded(.down))
        
        if let n = exclusion {
            let value = Int.random(in: range)
            return value == n ? Double(range.upperBound) : Double(value)
        } else {
            return Double(Int.random(in: range))
        }
    }
}

extension Array {
    var centerItem: Element? {
        guard self.count > 0 else { return nil }
        let index = self.count / 2
        return self[index]
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

extension Numeric where Self: CVarArg {
    func scoreString(digits: Int) -> String {
        return String(format: "%0\(digits)d", self)
    }
}

extension Collection where Element == Double {
    var mean: Double {
        reduce(0, +) / Double(count)
    }
}


