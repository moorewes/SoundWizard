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
        let stars = level.starsEarned
        let starUnfilled = UIImage(systemName: "star")
        let starFilled = UIImage(systemName: "star.fill")
        firstStarImageView.image = stars > 0 ? starFilled : starUnfilled
        secondStarImageView.image = stars > 1 ? starFilled : starUnfilled
        thirdStarImageView.image = stars > 2 ? starFilled : starUnfilled
    }

}
