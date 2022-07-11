//
//  FeedViewControllerTests.swift
//  
//
//  Created by Nicolò Pasini on 11/07/22.
//

import XCTest
import EssentialFeediOS

import UIKit

class FeedViewController {

    init(loader: FeedViewControllerTests.LoaderSpy) {}
}

class FeedViewControllerTests: XCTestCase {

    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        let _ = FeedViewController(loader: loader)

        XCTAssertEqual(loader.loadCallCount, 0)
    }

    // MARK: - Helpers

    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
    }
}
