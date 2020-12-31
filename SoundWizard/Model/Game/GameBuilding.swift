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
    private var bandCount: Int {
        format.bandCount.rawValue
    }
    
    func buildGame(gameHandler handler: GameHandling) -> AnyView {
        let game = EQMatchGame(
            level: self,
            practice: handler.state == .practicing,
            completionHandler: handler.completionHandler
        )
        return AnyView(EQMatchGameplayView(game: game))
    }
    
    var initialFilterData: [EQBellFilterData] {
        Array(0..<bandCount).map { index in
            let frequency = startFrequency(filterNumber: index)
            let gain = startGain()
            let freqRange = frequencyRange(filterNumber: index)
            let gainRange = self.gainRange()
            print(freqRange, gainRange)
            return EQBellFilterData(frequency: frequency,
                                    gain: gain,
                                    q: 2,
                                    frequencyRange: freqRange,
                                    dBGainRange: gainRange)
        }
    }
    
    func startFrequency(filterNumber: Int) -> Frequency {
        if let staticFreqs = staticFrequencies {
            return staticFreqs[filterNumber]
        }
        
        let percentage = Double(filterNumber) / Double(bandCount) + 0.5 / Double(bandCount)
        return AudioMath.frequency(percent: percentage, in: format.bandFocus.range)
    }
    
    private func startGain() -> Gain {
        if variesGain {
            return Gain.unity
        }
        
        let gain = Double(Int.random(in: -9...9))
        return Gain(dB: gain)
    }
    
    // TODO: Implement
    private func gainRange() -> ClosedRange<Double> {
        if format.mode == .fixedGain {
            let gain = startGain()
            return gain.dB...gain.dB
        }
        
        return -9.0...9.0
    }
    
    private func frequencyRange(filterNumber: Int) -> FrequencyRange {
        if format.mode == .fixedFrequency {
            let freq = startFrequency(filterNumber: filterNumber)
            return freq...freq
        }
        let startPercentage = Double(filterNumber) / Double(bandCount)
        let endPercentage = Double(filterNumber + 1) / Double(bandCount)
        let startFreq = AudioMath.frequency(percent: startPercentage, in: format.bandFocus.range)
        let endFreq = AudioMath.frequency(percent: endPercentage, in: format.bandFocus.range)
        
        return startFreq...endFreq
    }
}
