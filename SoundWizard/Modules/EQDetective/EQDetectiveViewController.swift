//
//  EQDetectiveViewController.swift
//  AudioKitExperiments
//
//  Created by Wes Moore on 10/26/20.
//

import UIKit

class EQDetectiveViewController: UIViewController {
    
    // MARK: - Properties
    
    var engine: EQDetectiveEngine!
        
    // MARK: IBOutlets
    
    @IBOutlet weak var graph: FrequencyGraphView!
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreDescriptionLabel: UILabel!
    @IBOutlet weak var currentFreqLabel: UILabel!
    @IBOutlet weak var solutionFreqLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var muteLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var eqBypassControl: UISegmentedControl!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet var currentFreqLabelXConstraint: NSLayoutConstraint!
    
    // MARK: - IBActions
    
    @IBAction func didTapStart() {
        engine.startNewRound()
    }
    
    @IBAction func didTapContinue() {
        engine.startNewTurn()
    }
    
    @IBAction func didTapSubmit() {
        let guess = graph.currentFreq()
        graph.showSolution()
        engine.submitGuess(guess)
    }
    
    
    @IBAction func didToggleDryWet(_ sender: UISegmentedControl) {
        let shouldBypass = sender.selectedSegmentIndex == 0
        engine.toggleFilter(bypass: shouldBypass)
    }
    
    @IBAction func didPanGraphView(_ sender: UIPanGestureRecognizer) {
        let movement = sender.translation(in: view).x
        sender.setTranslation(CGPoint.zero, in: view)

        graph.updateCurrentFreq(movement: movement)
        
        updateCurrentFreq()
    }
    
    @IBAction func didToggleAudio(sender: UIButton) {
        let shouldMute = sender.isSelected
        engine.toggleMute(mute: shouldMute)
        
        muteButton.isSelected.toggle()
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        engine = EQDetectiveEngine(vc: self)
                
        graph.setUp()
                
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        graph.setNeedsDisplay()
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func turnDidBegin(turn: EQDetectiveTurn) {
        let freq = turn.freqSolution
        graph.reset(solutionFreq: freq)
        updateSolutionFreqLabel(freq: freq)
        
        turnLabel.text = "Turn \(turn.number + 1)"
        
        updateViewForNewTurn(turn: turn)
    }
    
    func showResults(score: Float, octaveError: Float) {
        scoreLabel.text = "\(Int(score))"
        errorLabel.text = octaveString(octaveError)
        updateViewForResults()
    }
    
    // MARK: Private
    
    private func updateViewForNewTurn(turn: EQDetectiveTurn) {
        currentFreqLabel.isHidden = false
        resultsView.isHidden = true
        startButton.isHidden = true
        muteButton.isHidden = false
        submitButton.isHidden = false
        graph.isHidden = false
        eqBypassControl.isHidden = false
        muteButton.isSelected.toggle()
        continueButton.isHidden = true
        scoreDescriptionLabel.isHidden = false
        scoreLabel.isHidden = false
        instructionLabel.isHidden = false
    }
    
    private func updateViewForResults() {
        graph.showSolution()
        
        resultsView.isHidden = false
        submitButton.isHidden = true
        continueButton.isHidden = false
        instructionLabel.isHidden = true
    }
    
    private func setupView() {
        currentFreqLabel.isHidden = true
        graph.isHidden = true
        eqBypassControl.isHidden = true
        
        eqBypassControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        eqBypassControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        
        currentFreqLabelXConstraint.constant = self.graph.currentLineXPosition
        
        resultsView.isHidden = true
        scoreLabel.isHidden = true
        scoreDescriptionLabel.isHidden = true
        muteButton.isHidden = true
        muteLabel.isHidden = true
        scoreLabel.text = "0"
    }
    
    private func updateCurrentFreq() {
        let freq = graph.currentFreq()
        currentFreqLabel.text = freqString(freq)
        
        currentFreqLabelXConstraint.constant = graph.currentLineXPosition
        
        view.layoutIfNeeded()
    }
    
    private func updateSolutionFreqLabel(freq: Float) {
        solutionFreqLabel.text = freqString(freq)
    }
    
    // MARK: - Helper
    
    private func octaveString(_ octave: Float) -> String {
        var text = "\(octave) Octave"
        if abs(octave) != 1 {
            text.append("s")
        }
        return text
    }
    
    private func freqString(_ freq: Float) -> String {
        if freq / 1000.0 >= 1 {
            let freqString = String(freq / 1000.0)
            return freqString + " kHz"
        } else {
            return "\(Int(freq)) Hz"
        }
    }

}
