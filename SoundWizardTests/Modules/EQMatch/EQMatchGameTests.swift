//
//  EQMatchGameTests.swift
//  SoundWizardTests
//
//  Created by Wes Moore on 1/4/21.
//

@testable import SoundWizard
import XCTest

class EQMatchGameTests: XCTestCase {
    
    var sut: EQMatchGame!

    override func tearDownWithError() throws {
        sut = nil
    }

    func testFixedGainMode() {
        let level = EQMatchLevelBuilder.level(mode: .fixedGain)
        sut = EQMatchGame(level: level, practice: false, completionHandler: MockEQMatchCompletionHandler())
        sut.conductor = nil
        
        XCTAssertEqual(level.format.bandCount.rawValue, sut.guessFilterData.count)
        XCTAssertEqual(sut.guessFilterData.count, sut.solutionFilterData.count)
        
        while sut.turns.count < 10 && !sut.lives.isDead {
            XCTAssertEqual(sut.guessFilterData[0].gain, sut.solutionFilterData[0].gain)
            sut.action()
            sut.action()
        }
        
    }
    
    func testFixedFreqMode() {
        let level = EQMatchLevelBuilder.level(mode: .fixedFrequency)
        sut = EQMatchGame(level: level, practice: false, completionHandler: MockEQMatchCompletionHandler())
        sut.conductor = nil
        
        while sut.turns.count < 5 && !sut.lives.isDead {
            XCTAssertEqual(sut.guessFilterData[0].frequency, sut.solutionFilterData[0].frequency)
            sut.action()
            sut.action()
        }
    }
    
    func testFreqRanges() {
        let level = EQMatchLevelBuilder.level(bandCount: 3)
        sut = EQMatchGame(level: level, practice: false, completionHandler: MockEQMatchCompletionHandler())
        sut.conductor = nil
        
        let freqRanges = sut.guessFilterData.map { $0.frequencyRange }
        
        XCTAssertEqual(freqRanges[0].upperBound, freqRanges[1].lowerBound)
        XCTAssertEqual(freqRanges[1].upperBound, freqRanges[2].lowerBound)
    }
    
    func testSuccessfulGuess() {
        let level = EQMatchLevelBuilder.level()
        sut = EQMatchGame(level: level, practice: false, completionHandler: MockEQMatchCompletionHandler())
        sut.conductor = nil
        
        sut.guessFilterData = sut.solutionFilterData
        sut.action()
        
        let result = sut.turnResult
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.score.successLevel, .perfect)
    }
    
    func testFailedGuess() {
        let level = EQMatchLevelBuilder.level(mode: .fixedGain, bandCount: 3)
        sut = EQMatchGame(level: level, practice: false, completionHandler: MockEQMatchCompletionHandler())
        sut.conductor = nil
        
        sut.guessFilterData[0].frequency = sut.solutionFilterData[0].frequency * 6
        sut.action()
        
        let result = sut.turnResult
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.score.successLevel, .failed)
    }
}
