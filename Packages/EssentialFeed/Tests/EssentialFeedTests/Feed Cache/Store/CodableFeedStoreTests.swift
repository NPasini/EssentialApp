//
//  CodableFeedStoreTests.swift
//  
//
//  Created by Nicolò Pasini on 27/06/22.
//

import XCTest
import EssentialFeed
import Utilities

class CodableFeedStore {

    private struct CodableFeedImage: Codable {
        public let id: UUID
        public let url: URL
        public let location: String?
        public let description: String?

        var local: LocalFeedImage {
            LocalFeedImage(id: id, url: url, location: location, description: description)
        }

        init(_ image: LocalFeedImage) {
            id = image.id
            url = image.url
            location = image.location
            description = image.description
        }
    }

    private struct Cache: Codable {
        let timestamp: Date
        let feed: [CodableFeedImage]

        var localFeed: [LocalFeedImage] {
            feed.map { $0.local }
        }
    }

    private let storeURL: URL

    init(storeURL: URL) {
        self.storeURL = storeURL
    }

    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        if let data = try? Data(contentsOf: storeURL) {
            let decoder = JSONDecoder()
            let cache = try! decoder.decode(Cache.self, from: data)
            completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
        } else {
            completion(.empty)
        }
    }

    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
        let encoder = JSONEncoder()
        let cache = Cache(timestamp: timestamp, feed: feed.map(CodableFeedImage.init))
        let encoded = try! encoder.encode(cache)
        try! encoded.write(to: storeURL)
        completion(nil)
    }
}

class CodableFeedStoreTests: XCTestCase {

    override func setUp() {
        super.setUp()

        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("image-feed.store")
        try? FileManager.default.removeItem(at: storeURL)
    }

    override func tearDown() {
        super.tearDown()

        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("image-feed.store")
        try? FileManager.default.removeItem(at: storeURL)
    }

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache retrieval")

        sut.retrieve { result in
            switch result {
            case .empty:
                break
            default:
                XCTFail("Expected empty cache, got \(result) instead")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    // Proving there are no side effects
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache retrieval")

        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                case (.empty, .empty):
                    break
                default:
                    XCTFail("Expected retrieving twice empty cache, got \(firstResult) and \(secondResult) instead")
                }

                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 1.0)
    }

    func test_retrieveAfterInsertingToEmptyCache_deliversInsertedValues() {
        let timestamp = Date()
        let sut = makeSUT()
        let feed = uniqueImageFeed().locals
        let exp = expectation(description: "Wait for cache retrieval")

        sut.insert(feed, timestamp: timestamp) { insertionError in
            XCTAssertNil(insertionError, "Expected feed to be inserted successfully")

            sut.retrieve { retrievalResult in
                switch retrievalResult {
                case let .found(retrievedFeed, retrievedTimestamp):
                    XCTAssertEqual(retrievedFeed, feed)
                    XCTAssertEqual(retrievedTimestamp, timestamp)
                default:
                    XCTFail("Expected found result with feed \(feed) and timestamp \(timestamp), got \(retrievalResult) instead")
                }

                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 1.0)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CodableFeedStore {
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("image-feed.store")
        let sut = CodableFeedStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
