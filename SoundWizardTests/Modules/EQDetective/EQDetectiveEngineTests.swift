//
//  EQDetectiveEngineTests.swift
//  SoundWizardTests
//
//  Created by Wes Moore on 10/28/20.
//

@testable import SoundWizard
import XCTest

class EQDetectiveEngineTests: XCTestCase {
    
    var sut: EQDetectiveEngine!

    override func setUpWithError() throws {
        sut = EQDetectiveEngine(level: EQDetectiveLevel.level(1)!)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testStartNewRound() throws {
        sut.startNewRound()
        
        XCTAssertNotNil(sut.currentRound)
        XCTAssertNotNil(sut.currentTurn)
        XCTAssertEqual(sut.currentTurn?.number, 0)
    }

    func testStartNewTurn() throws {
        sut.startNewRound()
        sut.startNewTurn()
        
        XCTAssertEqual(sut.currentTurn?.number, 1)
    }
    
    func testSubmitGuess() {
        sut.startNewRound()
        sut.submitGuess(1000)
        
        XCTAssertNotNil(sut.currentTurn?.score)
        
        for _ in 0..<sut.level.numberOfTurns - 1 {
            sut.startNewTurn()
            sut.submitGuess(1000)
        }
        
        XCTAssertEqual(sut.currentRound?.turns.count, 10)
        XCTAssertEqual(sut.currentRound?.isComplete, true)
    }

}
