//
//  GameCollectionViewCell.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/2/20.
//

import UIKit

class GameCell: UICollectionViewCell {
    
    static let reuseID = "gameCell"
    
    var game: Game!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    func updateUI() {
        titleLabel.text = game.name
        levelLabel.text = "\(game.levels) Levels"
    }
    
}
