//
//  BandFocus.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/30/20.
//

import Foundation

enum BandFocus: Int, CaseIterable, Identifiable, UIDescribing {
    case all = 0, low, lowMid, mid, upperMid, high
    
    var id: Int { return self.rawValue }
    
    var range: FrequencyRange {
        switch self {
        case .all: return 40...16_000
        case .low: return 40...315
        case .lowMid: return 200...1_600
        case .mid: return 315...3_200
        case .upperMid: return 1_000...4_000
        case .high: return 2_000...16_000
        }
    }
    
    var referenceFrequencies: [Frequency] {
        switch self {
        case .all:
            return [40, 80, 160, 315, 630, 1250, 2500, 5000, 10_000, 20_000] //[40, 63, 125, 250, 500, 1000, 2000, 4000, 8000, 16_000]
        case .low:
            return [40, 50, 63, 80, 100, 125, 160, 200, 250, 315] // [55, 82, 123, 185, 277, 415]
        case .lowMid:
            return [200, 250, 315, 400, 500, 630, 800, 1000, 1250, 1600]
        case .mid:
            return [315, 400, 500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3150] //[315, 500, 800, 1250, 2000, 3100]
        case .upperMid:
            return [1000, 1250, 1600, 2000, 2500, 3150, 4000]
        case .high:
            return [2000, 2500, 3150, 4000, 5000, 6300, 8000, 10_000, 12_000, 16_000]
        }
    }
    
    var octaveSpan: Octave {
        return AudioMath.octaves(in: self.range)
    }
    
    var uiDescription: String {
        switch self {
        case .all: return "Full Range"
        case .low: return "Low Band"
        case .lowMid: return "Low Mids"
        case .mid: return "Mid Band"
        case .upperMid: return "Upper Mids"
        case .high: return "High Band"
        }
    }
    
    var uiRangeDescription: String {
        "\(self.range.lowerBound.shortString)Hz - \(self.range.upperBound.shortString)Hz"
    }
}
