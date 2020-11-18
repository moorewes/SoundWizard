//
//  GameViewModeling.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/17/20.
//

import SwiftUI

protocol GameViewModeling: ObservableObject {
    
    var level: Level { get set }
    
    func cancelGameplay()
    
    associatedtype ViewType
    
}
