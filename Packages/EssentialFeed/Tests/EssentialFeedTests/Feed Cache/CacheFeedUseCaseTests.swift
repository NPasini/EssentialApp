//
//  CacheFeedUseCaseTests.swift
//  
//
//  Created by Nicolò Pasini on 22/06/22.
//

import XCTest

class LoaclFeedLoader {

    init(store: FeedStore) {
    }
}

class FeedStore {
    var deleteCachedFeedCallCount = 0
}

class CacheFeedUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        let sut = LoaclFeedLoader(store: store)

        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
}
