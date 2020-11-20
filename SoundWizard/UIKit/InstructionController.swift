//
//  InstructionController.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/5/20.
//

import Foundation
import UIKit

protocol InstructionController: UIViewController {
    
    static var storyboardID: String { get }
    
    var level: Level! { get set }
    
    func updateUI()
    
}
