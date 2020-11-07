//
//  LevelTableViewCell.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/2/20.
//

import UIKit

class LevelCell: UITableViewCell {
    
    static let reuseID = "levelCell"
    
    var level: Level!
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var soundDescriptionLabel: UILabel!
    @IBOutlet weak var firstStarImageView: UIImageView!
    @IBOutlet weak var secondStarImageView: UIImageView!
    @IBOutlet weak var thirdStarImageView: UIImageView!
    
    func updateUI() {
        updateStarViews()
        levelLabel.text = "Level \(level.levelNumber)"
        soundDescriptionLabel.text = "\(level.audioSource.description)"
    }
    
    private func updateStarViews() {
        let stars = level.progress.starsEarned
        firstStarImageView.isHighlighted = stars > 0
        secondStarImageView.isHighlighted = stars > 1
        thirdStarImageView.isHighlighted = stars > 2
    }

}
