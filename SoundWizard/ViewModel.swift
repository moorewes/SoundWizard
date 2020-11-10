//
//  ViewModel.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/9/20.
//

import Foundation
import SwiftUI

class EQDetectiveGameplayManager: ObservableObject {
    
    @Published var engine = EQDetectiveEngine(level: EQDetectiveLevel.level(1)!)
    
    @Published var turnNumber: Int = 1
    
    @Published var graphDragOffset: CGFloat = 0.0
    
}
