//
//  EQDetectiveViewController.swift
//  AudioKitExperiments
//
//  Created by Wes Moore on 10/26/20.
//

import UIKit

class EQDetectiveViewController: UIViewController, GameplayController {
    
    // MARK: - Properties
    
    weak var delegate: GameplayDelegate!
    weak var level: Level!
    var engine: EQDetectiveEngine!
        
    // MARK: IBOutlets
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var graph: FrequencyGraphView!
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreDescriptionLabel: UILabel!
    @IBOutlet weak var scoreAdditionLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var currentFreqLabel: UILabel!
    @IBOutlet weak var solutionFreqLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var muteLabel: UILabel!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var eqBypassControl: UISegmentedControl!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet var currentFreqLabelXConstraint: NSLayoutConstraint!
    @IBOutlet var scoreAdditionLabelYConstraint: NSLayoutConstraint!
    @IBOutlet var inRoundViews: [UIView]!
    
    // MARK: Private
    
    var filterIsInteractive = false
    
    // MARK: - IBActions
    
    @IBAction func didTapContinue() {
        engine.startNewTurn()
    }
    
    @IBAction func didTapSubmit() {
        let guess = graph.currentFreq
        engine.submitGuess(guess)
    }
    @IBAction func didTapFinish() {
        delegate.didFinishGame()
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
        
        engine = EQDetectiveEngine(vc: self, level: level as! EQDetectiveLevel)
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        graph.setNeedsDisplay()
        engine.startNewRound()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        prepareToLeaveGame()
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func roundDidBegin(level: EQDetectiveLevel) {
        graph.setUp(for: level)
        progressBar.progress = 0
    }
    
    func turnDidBegin(turn: EQDetectiveTurn) {
        let freq = turn.freqSolution
        graph.reset(solutionFreq: freq)
        updateSolutionFreqLabel(freq: freq)
        
        turnLabel.text = "\(turn.number + 1) / \(level.numberOfTurns)"
        
        
        eqBypassControl.selectedSegmentIndex = 1
        
        filterIsInteractive = false
        updateViewForNewTurn(turn: turn)
    }
    
    func turnDidEnd(turn: EQDetectiveTurn,
                    turnScore: EQDetectiveTurnScore,
                    roundScore: Float) {
        scoreLabel.text = "\(Int(roundScore))"
        scoreAdditionLabel.text = "+ \(Int(turnScore.value))"
        errorLabel.text = octaveString(turn.octaveError)
        feedbackLabel.text = turnScore.randomFeedbackString()
        feedbackLabel.textColor = feedbackTextColor(for: turnScore.successLevel)
        graph.showSolution(successLevel: turnScore.successLevel)
        filterIsInteractive = true
        
        let progress = Float(turn.number + 1) / Float(level.numberOfTurns)
        progressBar.setProgress(progress, animated: true)
        
        updateViewForTurnResults()
        
        UIView.animate(withDuration: 4.0) {
            self.scoreAdditionLabel.alpha = 0
        } completion: { _ in
            self.scoreAdditionLabel.text = ""
            self.scoreAdditionLabel.alpha = 1
            self.scoreAdditionLabelYConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }
        
    }
    
    func roundDidEnd(round: EQDetectiveRound) {
        level.updateProgress(round: round)
        continueButton.isHidden = true
        finishButton.isHidden = false
    }
    
    // MARK: Private
    
    private func updateViewForNewTurn(turn: EQDetectiveTurn) {
        inRoundViews.forEach { $0.isHidden = false }
        resultsView.isHidden = true
        submitButton.isHidden = false
        continueButton.isHidden = true
    }
    
    private func updateViewForTurnResults() {
        resultsView.isHidden = false
        submitButton.isHidden = true
        continueButton.isHidden = false
        instructionLabel.isHidden = true
    }
    
    private func prepareToLeaveGame() {
        engine.stop()
    }
    
    private func setupView() {
        inRoundViews.forEach { $0.isHidden = false }
        
        eqBypassControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        eqBypassControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
                
        resultsView.isHidden = true
        muteButton.isSelected = true

        scoreLabel.text = "0"
        scoreAdditionLabel.text = ""
        
        let filterType = (level as! EQDetectiveLevel).filterGainDB
        instructionLabel.text = "Find the \(filterType) frequency"
    }
    
    private func updateCurrentFreq() {
        let freq = graph.currentFreq
        currentFreqLabel.text = freqString(freq)
        
        currentFreqLabelXConstraint.constant = graph.currentLineXPosition
        view.layoutIfNeeded()
        
        if filterIsInteractive {
            engine.previewFreq(freq)
        }
    }
    
    private func updateSolutionFreqLabel(freq: Float) {
        solutionFreqLabel.text = freqString(freq)
    }
    
    // MARK: - Helper
    
    private func feedbackTextColor(for successLevel: ScoreSuccessLevel) -> UIColor {
        switch successLevel {
        case .perfect: return UIColor.systemGreen
        case .great: return UIColor.systemGreen
        case .fair: return UIColor.systemGreen
        case .justMissed: return UIColor.orange
        case .failed: return UIColor.red
        }
    }
    
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
