//
//  Turn.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/25/20.
//

import Foundation

protocol Turn {
    
    var number: Int { get }
    var score: TurnScore? { get }
    
}
