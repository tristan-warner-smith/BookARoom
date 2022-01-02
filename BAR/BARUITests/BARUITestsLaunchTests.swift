//
//  BARUITestsLaunchTests.swift
//  BARUITests
//
//  Created by Tristan Warner-Smith on 02/01/2022.
//

import XCTest

final class BARUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.waitForExistence(timeout: 1))
    }
}
