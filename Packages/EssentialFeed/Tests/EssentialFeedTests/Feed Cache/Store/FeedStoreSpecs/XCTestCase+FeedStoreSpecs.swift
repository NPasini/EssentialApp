//
//  XCTestCase+FeedStoreSpecs.swift
//  
//
//  Created by Nicolò Pasini on 07/07/22.
//

import XCTest
import TestUtilities
import EssentialFeed

extension FeedStoreSpecs where Self: XCTestCase {

    func assertThatRetrieveDeliversEmptyOnEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }

    func assertThatRetrieveHasNoSideEffectsOnEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .success(.none), file: file, line: line)
    }

    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        let feed = uniqueImageFeed().locals
        let timestamp = Date()

        insert((feed, timestamp), to: sut)

        expect(sut, toRetrieve: .success(CachedFeed(feed: feed, timestamp: timestamp)), file: file, line: line)
    }

    func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        let feed = uniqueImageFeed().locals
        let timestamp = Date()

        insert((feed, timestamp), to: sut)

        expect(sut, toRetrieveTwice: .success(CachedFeed(feed: feed, timestamp: timestamp)), file: file, line: line)
    }

    func assertThatInsertDeliversNoErrorOnEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        let insertionError = insert((uniqueImageFeed().locals, Date()), to: sut)

        XCTAssertNil(insertionError, "Expected to insert cache successfully", file: file, line: line)
    }

    func assertThatInsertDeliversNoErrorOnNonEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueImageFeed().locals, Date()), to: sut)

        let insertionError = insert((uniqueImageFeed().locals, Date()), to: sut)

        XCTAssertNil(insertionError, "Expected to override cache successfully", file: file, line: line)
    }

    func assertThatInsertOverridesPreviouslyInsertedCacheValues(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueImageFeed().locals, Date()), to: sut)

        let latestFeed = uniqueImageFeed().locals
        let latestTimestamp = Date()
        insert((latestFeed, latestTimestamp), to: sut)

        expect(sut, toRetrieve: .success(CachedFeed(feed: latestFeed, timestamp: latestTimestamp)), file: file, line: line)
    }

    func assertThatDeleteDeliversNoErrorOnEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)

        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed", file: file, line: line)
    }

    func assertThatDeleteHasNoSideEffectsOnEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        deleteCache(from: sut)

        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }

    func assertThatDeleteDeliversNoErrorOnNonEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueImageFeed().locals, Date()), to: sut)

        let deletionError = deleteCache(from: sut)

        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed", file: file, line: line)
    }

    func assertThatDeleteEmptiesPreviouslyInsertedCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueImageFeed().locals, Date()), to: sut)

        deleteCache(from: sut)

        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }

    func assertThatSideEffectsRunSerially(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        var completedOperationsInOrder = [XCTestExpectation]()

        let op1 = expectation(description: "Operation 1")
        sut.insert(uniqueImageFeed().locals, timestamp: Date()) { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        }

        let op2 = expectation(description: "Operation 2")
        sut.deleteCachedFeed { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }

        let op3 = expectation(description: "Operation 3")
        sut.insert(uniqueImageFeed().locals, timestamp: Date()) { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        }

        wait(for: [op1, op2, op3], timeout: 5.0, enforceOrder: true)
    }
}

extension FeedStoreSpecs where Self: XCTestCase {

    func expect(_ sut: FeedStore, toRetrieveTwice expectedResult: FeedStore.RetrievalResult, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }

    func expect(_ sut: FeedStore, toRetrieve expectedResult: FeedStore.RetrievalResult, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")

        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.success(.none), .success(.none)),
                (.failure, .failure):
                break
            case let (.success(.some(expected)), .success(.some(retrieved))):
                XCTAssertEqual(expected.feed, retrieved.feed, file: file, line: line)
                XCTAssertEqual(expected.timestamp, retrieved.timestamp, file: file, line: line)
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    @discardableResult
    func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache insertion")
        var insertionError: Error?
        sut.insert(cache.feed, timestamp: cache.timestamp) { result in
            if case let .failure(error) = result { insertionError = error }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }

    @discardableResult
    func deleteCache(from sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache deletion")
        var deletionError: Error?
        sut.deleteCachedFeed { result in
            if case let .failure(error) = result { deletionError = error }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return deletionError
    }
}
