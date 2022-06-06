//
//  RemoteFeedLoaderTests.swift
//  
//
//  Created by Nicolò Pasini on 03/06/22.
//

import XCTest

class RemoteFeedLoader {

    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func load() {
        let url = URL(string: "https://a-url.com")!
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {

    private(set) var requestedURL: URL?

    func get(from url: URL) {
        requestedURL = url
    }
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(client: client)

        XCTAssertNil(client.requestedURL)
    }

    func test_load_requestDataFromURL() {
        // ARRANGE - GIVEN
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client)

        // ACT - WHEN
        sut.load()

        // ASSERT - THEN
        XCTAssertNotNil(client.requestedURL)
    }
}
