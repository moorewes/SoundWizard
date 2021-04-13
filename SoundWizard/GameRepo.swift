//
//  GameRepo.swift
//  SoundWizard
//
//  Created by Wesley Moore on 4/5/21.
//

import Foundation

class GameRepo {
    private var localDataSource: CoreDataManager = .shared
    private var allLevels: [Level] = []
    private let user: User!
    
    var dailyLevels: [Level] {
        let eqmLevels = levels(for: .eqMatch)
        var result = [Level]()
        while result.count < 10 {
            let int = Int.random(in: 0..<eqmLevels.count)
            result.append(eqmLevels[int])
        }
        return result
    }
    
    var levelPacks: [LevelPack] = []
        
    init() {
        self.user = localDataSource.user()
        allLevels = user.gameData?.allLevels() ?? []
        makeTestPacks()
    }
    
    func levels(for game: Game) -> [Level] {
        allLevels.filter { $0.game == game }
    }
    
    func levels<L: Level>() -> [L] {
        allLevels.compactMap { $0 as? L}
    }
    
    private func makeTestPacks() {
        levelPacks.append(LevelPack(name: "Starter Pack", id: "pack1", levels: Array(allLevels.prefix(5)) + levels(for: .gainBrain)))
        levelPacks.append(LevelPack(name: "Frequency Freak", id: "pack2", levels: Array(allLevels.suffix(5))))
    }    
}
