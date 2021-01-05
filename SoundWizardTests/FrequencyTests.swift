//
//  FrequencyTests.swift
//  SoundWizardTests
//
//  Created by Wes Moore on 11/25/20.
//

@testable import SoundWizard
import XCTest

class FrequencyTests: XCTestCase {

    func testFrequencyPercentage40() {
        let range: FrequencyRange = 20...20_000
        let testFreq: Frequency = 40
        
        let percentage = testFreq.octavePercentage(in: range)!.rounded(places: 1)
        
        XCTAssertEqual(percentage, 0.1)
    }
    
    func testFrequencyPercentageLower() {
        let range: FrequencyRange = 40...4_000
        let testFreq: Frequency = 40.0
        
        let percentage = testFreq.octavePercentage(in: range)!.rounded(places: 2)
        
        XCTAssertEqual(percentage, 0.0)
    }
    
    func testFrequencyPercentageUpper() {
        let range: FrequencyRange = 40...4_000
        let testFreq: Frequency = 4000.0
        
        let percentage = testFreq.octavePercentage(in: range)!.rounded(places: 2)
        
        XCTAssertEqual(percentage, 1.0)
    }
    
    func testFrequencyPercentageMiddle() {
        let range: FrequencyRange = 40...4_000
        let testFreq: Frequency = 320.0
        
        let percentage = testFreq.octavePercentage(in: range)!.rounded(places: 2)
        
        XCTAssertEqual(percentage, 0.45)
    }

}
