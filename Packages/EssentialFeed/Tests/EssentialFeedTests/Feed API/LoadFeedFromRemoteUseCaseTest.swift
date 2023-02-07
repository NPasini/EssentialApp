//
//  LoadFeedFromRemoteUseCaseTests.swift
//  
//
//  Created by Nicolò Pasini on 03/06/22.
//

import XCTest
import TestUtilities
import EssentialFeed

class LoadFeedFromRemoteUseCaseTests: XCTestCase {

    func test_load_deliversErrorOnNon200HttpResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(APIError.invalidData), when: {
                let json = makeItemsJson([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }

    func test_load_deliversErrorOn200HTTPResponseWithInvalidJson() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: failure(APIError.invalidData), when: {
            let invalidJson = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJson)
        })
    }

    func test_load_deliversInvalidDataErrorOn200HTTPResponseWithPartiallyValidJSONItems() {
        let (sut, client) = makeSUT()

        let validItem = makeItem(
            id: UUID(),
            imageURL: URL(string: "http://another-url.com")!
        ).json

        let invalidItem = ["invalid": "item"]

        let items = [validItem, invalidItem]

        expect(sut, toCompleteWith: .failure(APIError.invalidData), when: {
            let json = makeItemsJson(items)
            client.complete(withStatusCode: 200, data: json)
        })
    }

    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJsonList() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .success([]), when: {
            let emptyListJson = Data(makeItemsJson([]))
            client.complete(withStatusCode: 200, data: emptyListJson)
        })
    }

    func test_load_deliversItemsOn200HTTPResponseWithJsonItems() {
        let (sut, client) = makeSUT()
        let item1 = makeItem(
            id: UUID(),
            imageURL: URL(string: "https://a-url.com")!
        )
        let item2 = makeItem(
            id: UUID(),
            description: "a description",
            location: "a location",
            imageURL: URL(string: "https://another-url.com")!
        )

        let items = [item1.model, item2.model]
        let json = makeItemsJson([item1.json, item2.json])

        expect(sut, toCompleteWith: .success(items), when: {
            client.complete(withStatusCode: 200, data: json)
        })
    }

    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(sut)
        return (sut, client)
    }

    private func failure(_ error: APIError) -> RemoteFeedLoader.Result {
        .failure(error)
    }

    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedImage, json: [String: Any]) {
        let model = FeedImage(id: id, url: imageURL, location: location, description: description)
        let json = [
            "id": id.uuidString,
            "image": imageURL.absoluteString,
            "location": location,
            "description": description
        ].compactMapValues { $0 }

        return (model, json)
    }

    private func makeItemsJson(_ items: [[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }

    private func expect(_ sut: RemoteFeedLoader, toCompleteWith expectedResult: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.load() { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError as NSError, expectedError as NSError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()

        wait(for: [exp], timeout: 1.0)
    }
}
