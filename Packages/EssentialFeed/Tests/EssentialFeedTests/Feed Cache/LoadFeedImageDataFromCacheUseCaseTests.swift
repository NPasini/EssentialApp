//
//  LoadFeedImageDataFromCacheUseCaseTests.swift
//  
//
//  Created by Nicolò Pasini on 31/07/22.
//

import XCTest
import EssentialFeed

class LocalFeedImageDataLoader {

    private let store: FeedStore

    init(store: FeedStore) {
        self.store = store
    }
}

final class LoadFeedImageDataFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStore() {
        let (_, store) = makeSUT()

        XCTAssertTrue(store.receivedMessages.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}
