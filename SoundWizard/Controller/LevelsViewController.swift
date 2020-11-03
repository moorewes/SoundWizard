//
//  LevelsViewController.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/2/20.
//

import UIKit

class LevelsViewController: UIViewController {
    
    var game: Game!
    lazy var levels: [Level] = { game.levels }()
    
    var segueID: String {
        switch game {
        case .eqDetective:
            return "showEQDetective"
        default: return ""
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = game.name
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard var vc = segue.destination as? GameplayController,
              let level = sender as? Level else { return }
        vc.game = game
        vc.level = level
    }

}

// MARK: - UITableView Data Source

extension LevelsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LevelCell.reuseID) as! LevelCell
        cell.level = levels[indexPath.row]
        cell.updateUI()
        return cell
    }
    
}

// MARK: - UITableView Delegate

extension LevelsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let level = levels[indexPath.row]
        performSegue(withIdentifier: segueID, sender: level)
    }
    
}
