//
//  ViewModel.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/9/20.
//

import Foundation
import SwiftUI

class EQDetectiveViewModel: ObservableObject {
    
    @Published var engine = EQDetectiveEngine(level: EQDetectiveLevel.level(1)!)
    
    @Published var turnNumber: Int = 1
    
    @Published var freqSliderPercentage: CGFloat = 0.5
    
    @Published var graphDragOffset: CGFloat = 0.0
    @Published var lastTranslation: CGFloat = 0.0
    
    @Published var octaveRange: Float = 2.0
    
    var selectedFreq: Float {
        let octave = Float(10 * freqSliderPercentage)
        return AudioCalculator.freq(fromOctave: octave)
    }
    
    func didPanGraph(offset: CGFloat) {
        graphDragOffset = offset - lastTranslation
        lastTranslation = offset
    }
    
    func didEndGraphPan() {
        lastTranslation = 0.0
    }
    
    func didTapContinue() {
        //engine.startNewTurn()
    }
    
    func didTapSubmit() {
        //let guess = graph.currentFreq
        //engine.submitGuess(guess)
    }
    func didTapFinish() {
        //delegate.didFinishGame()
    }
    
    
    func didToggleDryWet() {
        //let shouldBypass = sender.selectedSegmentIndex == 0
        //engine.toggleFilter(bypass: shouldBypass)
    }
    
    func didPanGraphView() {
        //let movement = sender.translation(in: view).x
        //sender.setTranslation(CGPoint.zero, in: view)

        //graph.updateCurrentFreq(movement: movement)
        
        //updateCurrentFreq()
    }
    
    func didToggleAudio() {
        //let shouldMute = sender.isSelected
        //engine.toggleMute(mute: shouldMute)
        
        //muteButton.isSelected.toggle()
    }
    
}
