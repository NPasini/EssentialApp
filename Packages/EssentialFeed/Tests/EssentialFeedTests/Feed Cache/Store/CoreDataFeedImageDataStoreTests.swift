//
//  CoreDataFeedImageDataStoreTests.swift
//  
//
//  Created by Nicolò Pasini on 09/08/22.
//

import XCTest
import EssentialFeed
import TestUtilities

extension CoreDataFeedStore: FeedImageDataStore {

    public func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        completion(.success(.none))
    }

    public func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {
    }
}

class CoreDataFeedImageDataStoreTests: XCTestCase {

    func test_retrieveImageData_deliversNotFoundWhenEmpty() {
        let sut = makeSUT()

        expect(sut, toCompleteRetrievalWith: notFound(), for: anyURL())
    }

    // - MARK: Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> FeedImageDataStore {
        let sut = try! CoreDataFeedStore(storeURL: inMemoryStoreURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private var inMemoryStoreURL: URL {
        URL(fileURLWithPath: "/dev/null")
            .appendingPathComponent("\(type(of: self)).store")
    }

    private func notFound() -> FeedImageDataStore.RetrievalResult {
        return .success(.none)
    }

    private func expect(_ sut: FeedImageDataStore, toCompleteRetrievalWith expectedResult: FeedImageDataStore.RetrievalResult, for url: URL,  file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.retrieve(dataForURL: url) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success( receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)

            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}
