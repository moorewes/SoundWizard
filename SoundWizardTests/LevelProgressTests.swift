//
//  LevelProgressTests.swift
//  SoundWizardTests
//
//  Created by Wes Moore on 11/6/20.
//

@testable import SoundWizard
import XCTest

class LevelProgressTests: XCTestCase {
    
    var sut: LevelProgress!
    
    override func setUpWithError() throws {
        let controller = UserProgressManagerMock()
        sut = LevelProgress(context: controller.container.viewContext)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }

    func testTopScore() {
        sut.scores = [300, 50, 0, 120, 5000, 300, 5000]
        
        XCTAssertEqual(sut.topScore, 5000)
    }

}
