//
//  LevelSummaryViewController.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/4/20.
//

import UIKit

class LevelSummaryViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: Internal
    
    var level: Level!
    
    // MARK: Private
    
    // MARK: IBOutlets
    
    @IBOutlet weak var topUserScoreLabel: UILabel!
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star1ScoreLabel: UILabel!
    @IBOutlet weak var star2ScoreLabel: UILabel!
    @IBOutlet weak var star3ScoreLabel: UILabel!
    @IBOutlet weak var instructionsContainerView: UIView!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    // MARK: - Methods
    
    // MARK: IBActions
    
    @IBAction func didTapStartButton() {
        performSegue(withIdentifier: "showEQDetectiveGame", sender: nil)
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        updateScore()
    }
    

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showEQDetectiveGame":
            guard let vc = segue.destination as? EQDetectiveViewController else { return }
            vc.delegate = self
            vc.level = level as! EQDetectiveLevel
        default:
            break
        }
        
    }
    
    // MARK: Internal Methods
    
    // MARK: Private Methods
    
    func setupView() {
        title = "Level \(level.levelNumber)"
        
        setupInstructionsView()
                
        star1ScoreLabel.text = "\(level.starScores[0])"
        star2ScoreLabel.text = "\(level.starScores[1])"
        star3ScoreLabel.text = "\(level.starScores[2])"
    }
    
    func setupInstructionsView() {
        let id = instructionVCStoryboardID()
        guard let childVC = storyboard?.instantiateViewController(identifier: id) as? InstructionController else { return }
        
        childVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(childVC)
        childVC.view.frame = instructionsContainerView.bounds
        instructionsContainerView.addSubview(childVC.view)
        
        let viewsDict: [String: Any] = ["subView": childVC.view!]
        instructionsContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|", options: [], metrics: nil, views: viewsDict))
        instructionsContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|", options: [], metrics: nil, views: viewsDict))
                
        childVC.level = level
    }
    
    func updateScore() {
        guard let topScore = level.progress.topScore else {
            topUserScoreLabel.text = "0"
            return
        }
        
        topUserScoreLabel.text = "\(topScore)"
        updateStarViews(score: topScore)
    }
    
    func updateStarViews(score: Int) {
        star1ImageView.isHighlighted = score >= level.starScores[0]
        star2ImageView.isHighlighted = score >= level.starScores[1]
        star3ImageView.isHighlighted = score >= level.starScores[2]
    }
    
    private func instructionVCStoryboardID() -> String {
        switch level.game {
        case .eqDetective: return EQDetectiveInstructionViewController.storyboardID
        }
    }

}

extension LevelSummaryViewController: GameplayDelegate {
    
    func didFinishGame() {
        updateScore()
        navigationController?.popViewController(animated: true)
    }
}

