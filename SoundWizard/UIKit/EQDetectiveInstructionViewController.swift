//
//  EQDetectiveInstructionViewController.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/5/20.
//

import UIKit

class EQDetectiveInstructionViewController: UIViewController, InstructionController {
    
    static let storyboardID = "EQDetectiveInstruction"
    
    weak var level: Level! {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var bellCurveView: EQDetectiveInstructionUIView!
    @IBOutlet weak var dbLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var dbLabelTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var instructionLabelTopSpaceConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateUI()
    }


    func updateUI() {
        guard let level = level as? EQDetectiveLevel else { fatalError() }
        
        let gain = level.filterGainDB
        
        bellCurveView.bellGainDB = gain
        bellCurveView.setNeedsDisplay()
        
        dbLabel.text = level.filterGainDB.uiString + " dB"
                
        dbLabelTopSpaceConstraint.constant = dbLabelTopSpaceConstant(aboveCurve: gain > 0)
        instructionLabelTopSpaceConstraint.constant = instructionLabelTopSpaceConstant(aboveCurve: gain < 0)
    }
    
    private func dbLabelTopSpaceConstant(aboveCurve: Bool) -> CGFloat {
        let bellPeak = bellCurveView.bellPeakY()
        return aboveCurve ? bellPeak - 10 - dbLabel.frame.height : bellPeak + 10
    }
    
    private func instructionLabelTopSpaceConstant(aboveCurve: Bool) -> CGFloat {
        return aboveCurve ? bellCurveView.bounds.height / 4 : bellCurveView.bounds.height / 1.5
    }
    
}
