//
//  GameHandling.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/18/20.
//

import SwiftUI

protocol GameHandling {
    var level: Level { get }
    var state: GameViewState { get }
    var gameBuilder: GameBuilding { get }
    var startHandler: GameStartHandling { get }
    var completionHandler: GameCompletionHandling { get }
}

protocol GameStartHandling {
    func play() -> Void
    func practice() -> Void
}

protocol GameCompletionHandling {
    func finish(score: GameScore) -> Void
    func quit() -> Void
}

protocol GameTransitionHandling: GameStartHandling, GameCompletionHandling {}
