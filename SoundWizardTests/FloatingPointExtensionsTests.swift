//
//  FloatingPointExtensionsTests.swift
//  SoundWizardTests
//
//  Created by Wes Moore on 11/25/20.
//

@testable import SoundWizard
import XCTest

class FloatingPointExtensionsTests: XCTestCase {
    
    func testRoundedTo1() {
        let exactValue = 30.5
        
        let roundedValue = exactValue.rounded(to: 1)
        
        XCTAssertEqual(roundedValue, 31)
    }
    
    func testRoundedTo2() {
        let exactValue = 1003.31
        
        let roundedValue = exactValue.rounded(to: 2)
        
        XCTAssertEqual(roundedValue, 1004)
    }
    
    func testRoundedTo5() {
        let exactValue = 1003.31
        
        let roundedValue = exactValue.rounded(to: 5)
        
        XCTAssertEqual(roundedValue, 1005)
    }
    
    func testRoundedTo10() {
        let exactValue = 5235.0
        
        let roundedValue = exactValue.rounded(to: 10)
        
        XCTAssertEqual(roundedValue, 5240)
    }
    
    func testRoundedTo100() {
        let exactValue = 1050.01
        
        let roundedValue = exactValue.rounded(to: 100)
        
        XCTAssertEqual(roundedValue, 1100)
    }
    
    

}
