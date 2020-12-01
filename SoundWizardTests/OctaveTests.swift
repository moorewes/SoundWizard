//
//  OctaveTests.swift
//  SoundWizardTests
//
//  Created by Wes Moore on 11/26/20.
//

@testable import SoundWizard
import XCTest

class OctaveTests: XCTestCase {

    func testOctaveInitWith2() {
        let freq: Frequency = 200.0
        let baseFreq: Frequency = 50.0
        
        let octave = Octave_(frequency: freq, baseFrequency: baseFreq)
        
        XCTAssertEqual(octave.value, 2.0)
    }
    
    func testOctaveInitWith3() {
        let freq: Frequency = 400.0
        let baseFreq: Frequency = 50.0
        
        let octave = Octave_(frequency: freq, baseFrequency: baseFreq)
        
        XCTAssertEqual(octave.value, 3.0)
    }    

}
