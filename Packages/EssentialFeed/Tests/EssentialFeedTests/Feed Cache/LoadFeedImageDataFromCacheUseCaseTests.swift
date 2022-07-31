//
//  LoadFeedImageDataFromCacheUseCaseTests.swift
//  
//
//  Created by Nicolò Pasini on 31/07/22.
//

import XCTest
import EssentialFeed
import TestUtilities

protocol FeedImageDataStore {
    func retrieve(dataForURL url: URL)
}

class LocalFeedImageDataLoader {

    private let store: FeedImageDataStore

    init(store: FeedImageDataStore) {
        self.store = store
    }

    func loadImageData(from url: URL) {
        store.retrieve(dataForURL: url)
    }
}

final class LoadFeedImageDataFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStore() {
        let (_, store) = makeSUT()

        XCTAssertTrue(store.receivedMessages.isEmpty)
    }

    func test_loadImageData_requestsDataFromStore() {
        let url = anyURL()
        let (sut, store) = makeSUT()

        sut.loadImageData(from: url)

        XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: url)])
    }

    // MARK: - Helpers

    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: StoreSpy) {
        let store = StoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }

    private class StoreSpy: FeedImageDataStore {

        enum Message: Equatable {
            case retrieve(dataFor: URL)
        }

        private(set) var receivedMessages = [Message]()

        func retrieve(dataForURL url: URL) {
            receivedMessages.append(.retrieve(dataFor: url))
        }
    }
}
