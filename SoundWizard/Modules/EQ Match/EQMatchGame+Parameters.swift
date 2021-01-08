//
//  EQMatchGame+Parameters.swift
//  SoundWizard
//
//  Created by Wes Moore on 1/7/21.
//

import Foundation

extension EQMatchGame {
    enum Parameters {
        static let fullGainRange = -9.0...9.0
        static let easiestGainRange = 4.0...fullGainRange.upperBound
        static let positiveGainRange = 1.0...fullGainRange.upperBound
        
        static let filterQ = 2.0
        
        static let minOctaveDistanceBetweenSolutionFrequencies = 0.5
        
        static let gameStartDelay = 1.0
        static let turnsPerStage = 5
        static var timeBetweenTurns: Double = 1.2
        static let baseErrorMultiplier: Double = 0.7
    }
}
