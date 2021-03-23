//
//  GameBuilding.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/24/20.
//

import SwiftUI

extension Game {
    static func build(handler: GameHandling) -> AnyView {
        switch handler.level.game {
        case .eqDetective:
            if let level = handler.level as? EQDLevel {
                let game = EQDetectiveGame(level: level,
                                           practice: handler.state == .practicing,
                                           completionHandler: handler.completionHandler
                )
                return AnyView(EQDetectiveGameplayView(game: game))
            }
        case .eqMatch:
            if let level = handler.level as? EQMatchLevel {
                let game = EQMatchGame(
                    level: level,
                    practice: handler.state == .practicing,
                    completionHandler: handler.completionHandler
                )
                return AnyView(EQMatchGameplayView(game: game))
            }
        default:
            break
        }
        
        return AnyView(EmptyView())
    }
}

//protocol GameBuilding {
//    func buildGame(gameHandler handler: GameHandling) -> AnyView
//}

//
//extension EQDLevel: GameBuilding {
//    func buildGame(gameHandler handler: GameHandling) -> AnyView {
//        let game = EQDetectiveGame(level: self,
//                                   practice: handler.state == .practicing,
//                                   completionHandler: handler.completionHandler
//        )
//        return AnyView(EQDetectiveGameplayView(game: game))
//    }
//}
//
//extension EQMatchLevel: GameBuilding {
//    func buildGame(gameHandler handler: GameHandling) -> AnyView {
//        let game = EQMatchGame(
//            level: self,
//            practice: handler.state == .practicing,
//            completionHandler: handler.completionHandler
//        )
//        return AnyView(EQMatchGameplayView(game: game))
//    }
//}
