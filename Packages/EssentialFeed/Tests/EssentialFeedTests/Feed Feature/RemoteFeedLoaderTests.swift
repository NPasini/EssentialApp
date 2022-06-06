//
//  RemoteFeedLoaderTests.swift
//  
//
//  Created by Nicolò Pasini on 03/06/22.
//

import XCTest
import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertNil(client.requestedURL)
    }

    func test_load_requestsDataFromURL() {
        // ARRANGE - GIVEN
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        // ACT - WHEN
        sut.load()

        // ASSERT - THEN
        XCTAssertEqual(client.requestedURL, url)
    }

    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load()
        sut.load()

        XCTAssertEqual(client.requestedURL, url)
        XCTAssertEqual(client.requestedURLCallCount, 2)
    }

    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }

    private class HTTPClientSpy: HTTPClient {

        private(set) var requestedURL: URL?
        private(set) var requestedURLCallCount: Int = 0

        func get(from url: URL) {
            requestedURL = url
            requestedURLCallCount += 1
        }
    }
}
