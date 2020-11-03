//
//  GameplayController.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/2/20.
//

import Foundation

protocol GameplayController {
    var game: Game! { get set }
    var level: Level! { get set }
}
