//
//  FeedPresenterTests.swift
//  
//
//  Created by Nicolò Pasini on 23/07/22.
//

import XCTest
import EssentialFeed
import TestUtilities

class FeedPresenterTests: XCTestCase {

    func test_title_isLocalized() {
        XCTAssertEqual(FeedPresenter.title, localized("FEED_VIEW_TITLE", table: "Feed"))
    }
}
