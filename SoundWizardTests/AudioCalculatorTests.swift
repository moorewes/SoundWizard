//
//  AudioCalculatorTests.swift
//  SoundWizardTests
//
//  Created by Wes Moore on 11/18/20.
//

@testable import SoundWizard
import XCTest

class AudioCalculatorTests: XCTestCase {

    func testRandomFreq() throws {
        for _ in 0...1000 {
            let range: ClosedRange<Float> = 40.0...16_000.0
            let randomFreq = AudioMath.randomFreq(in: range, repelEdges: false)
            if !range.contains(randomFreq) {
                fatalError()
            }
            XCTAssertTrue(randomFreq <= range.upperBound)
            XCTAssertTrue(randomFreq >= range.lowerBound)
        }
    }
    
    func testDBToPerc() {
        let dB: Float = 3
        let gain = Gain(dB: dB)
        let percentage = gain.percentage.rounded(places: 1)
        XCTAssertEqual(percentage, 2)
    }
    
    func testPercToDB() {
        let percentage: Float = 2
        let dB = Gain(percentage: percentage).dB.rounded(places: 1)
        XCTAssertEqual(dB, 3)
    }
    
}
