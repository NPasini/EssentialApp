//
//  EssentialAppUITests.swift
//  EssentialAppUITests
//
//  Created by Nicolò Pasini on 09/08/22.
//

import XCTest

class EssentialAppUITests: XCTestCase {

    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let app = XCUIApplication()

        app.launch()

        XCTAssertEqual(app.cells.count, 22)
        XCTAssertEqual(app.cells.firstMatch.images.count, 1)
    }
}
