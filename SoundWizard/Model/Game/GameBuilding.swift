//
//  GameBuilding.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/24/20.
//

import SwiftUI

protocol GameBuilding {
    func buildGame(gameHandler handler: GameHandling) -> AnyView
}

extension EQDLevel: GameBuilding {
    func buildGame(gameHandler handler: GameHandling) -> AnyView {
        let game = EQDetectiveGame(level: self,
                                   practice: handler.state == .practicing,
                                   completionHandler: handler.completionHandler
        )
        return AnyView(EQDetectiveGameplayView(game: game))
    }
}

extension EQMatchLevel: GameBuilding {
    func buildGame(gameHandler handler: GameHandling) -> AnyView {
        let game = EQMatchGame(
            level: self,
            practice: handler.state == .practicing,
            completionHandler: handler.completionHandler
        )
        return AnyView(EQMatchGameplayView(game: game))
    }
    
    var initialFilterData: [EQBellFilterData] {
        Array(0..<filterCount).map { index in
            let frequency = startFrequency(filterNumber: index)
            let range = frequencyRange(filterNumber: index)
            print(range)
            return EQBellFilterData(frequency: frequency, gain: Gain(dB: 0), q: 2, frequencyRange: range)
        }
    }
    
    private func startFrequency(filterNumber: Int) -> Frequency {
        if let staticFreqs = staticFrequencies {
            return staticFreqs[filterNumber]
        }
        
        let percentage = Float(filterNumber) / Float(filterCount) + 0.5 / Float(filterCount)
        return AudioMath.frequency(percent: percentage, in: bandFocus.range)
    }
    
    private func frequencyRange(filterNumber: Int) -> FrequencyRange {
        let startPercentage = Float(filterNumber) / Float(filterCount)
        let endPercentage = Float(filterNumber + 1) / Float(filterCount)
        let startFreq = AudioMath.frequency(percent: startPercentage, in: bandFocus.range)
        let endFreq = AudioMath.frequency(percent: endPercentage, in: bandFocus.range)
        
        return startFreq...endFreq
    }
}
