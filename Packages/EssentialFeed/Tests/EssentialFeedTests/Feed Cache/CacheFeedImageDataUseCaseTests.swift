//
//  CacheFeedImageDataUseCaseTests.swift
//  
//
//  Created by Nicolò Pasini on 01/08/22.
//

import XCTest
import TestUtilities
import EssentialFeed

class CacheFeedImageDataUseCaseTests: XCTestCase {

    func test_saveImageDataForURL_requestsImageDataInsertionForURL() {
        let url = anyURL()
        let data = anyData()
        let (sut, store) = makeSUT()

        sut.save(data, for: url) { _ in }

        XCTAssertEqual(store.receivedMessages, [.insert(data: data, for: url)])
    }

    // MARK: - Helpers

    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: FeedImageDataStoreSpy) {
        let store = FeedImageDataStoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}
