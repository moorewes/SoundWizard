//
//  UserProgressManagerTests.swift
//  SoundWizardTests
//
//  Created by Wes Moore on 11/6/20.
//

@testable import SoundWizard
import XCTest

class UserProgressManagerTests: XCTestCase {
    
    var sut: CoreDataManager!
    
    override func setUpWithError() throws {
        sut = UserProgressManagerMock()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testNoProgressForGame() throws {
        let progress = sut.progress(for: Game.eqDetective)
        
        XCTAssertTrue(progress.isEmpty)
    }
    
    func testSomeProgressForGame() {
        let level = EQDetectiveLevel.level(1)!
        let scores = [300, 400, 600]
        addProgress(level: level, scores: scores)
        
        let progress = sut.progress(for: Game.eqDetective).first
        
        XCTAssertEqual(progress?.scores, scores)
        XCTAssertEqual(progress?.gameID, Game.eqDetective.id)
    }
    
    func testProgressForLevelNew() {
        let level = EQDetectiveLevel.level(1)!
        let progress = sut.progress(for: level)
        
        XCTAssertEqual(progress.gameID, level.game.id)
        XCTAssertEqual(progress.gameName, level.game.name)
        XCTAssertEqual(progress.level, level.levelNumber)
        XCTAssertEqual(progress.scores, [])
        XCTAssertEqual(progress.starsEarned, 0)
        
    }
    
    func testProgressForLevelExisting() {
        let level = EQDetectiveLevel.level(2)!
        let scores = [0, 40, 100]
        addProgress(level: level, scores: scores)
        
        let progress = sut.progress(for: level)
        
        XCTAssertEqual(progress.gameID, level.game.id)
        XCTAssertEqual(progress.gameName, level.game.name)
        XCTAssertEqual(progress.level, level.levelNumber)
        XCTAssertEqual(progress.scores, scores)
    }
    
    func testSave() {
        let level = EQDetectiveLevel.level(2)!
        let scores = [0, 40, 100]
        addProgress(level: level, scores: scores)
        
        let fetched = sut.progress(for: level.game)
        
        XCTAssertFalse(fetched.isEmpty)
    }
    
    // MARK: - Helper
    
    func addProgress(level: Level, scores: [Int]) {
        let progress = sut.progress(for: level)
        progress.scores = scores
        sut.save()
    }

}
