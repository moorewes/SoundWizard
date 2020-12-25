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
            let frequency = centerFrequency(filterNumber: index)
            return EQBellFilterData(frequency: frequency, gain: Gain(dB: 0), q: 4)
        }
    }
    
    private func centerFrequency(filterNumber: Int) -> Frequency {
        let percentage = Float(filterNumber) / Float(filterCount) + 0.5 / Float(filterCount)
        return AudioMath.frequency(percent: percentage, in: bandFocus.range)
    }
    
}
