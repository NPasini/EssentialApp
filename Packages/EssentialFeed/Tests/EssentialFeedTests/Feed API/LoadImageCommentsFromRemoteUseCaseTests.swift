//
//  LoadImageCommentsFromRemoteUseCaseTests.swift
//  
//
//  Created by nicolo.pasini on 06/02/23.
//

import XCTest
import EssentialFeed

class LoadImageCommentsFromRemoteUseCaseTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load() { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load() { _ in }
        sut.load() { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: failure(APIError.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }

    func test_load_deliversErrorOnNon2xxHttpResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 150, 300, 400, 500]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(APIError.invalidData), when: {
                let json = makeItemsJson([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }

    func test_load_deliversErrorOn2xxHTTPResponseWithInvalidJson() {
        let (sut, client) = makeSUT()

        let samples = [200, 201, 250, 280, 299]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(APIError.invalidData), when: {
                let invalidJson = Data("invalid json".utf8)
                client.complete(withStatusCode: code, data: invalidJson, at: index)
            })
        }
    }

    func test_load_deliversInvalidDataErrorOn2xxHTTPResponseWithPartiallyValidJSONItems() {
        let (sut, client) = makeSUT()

        let validItem = makeItem(
            id: UUID(),
            imageURL: URL(string: "http://another-url.com")!
        ).json

        let invalidItem = ["invalid": "item"]

        let items = [validItem, invalidItem]

        let samples = [200, 201, 250, 280, 299]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(APIError.invalidData), when: {
                let json = makeItemsJson(items)
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }

    func test_load_deliversNoItemsOn2xxHTTPResponseWithEmptyJsonList() {
        let (sut, client) = makeSUT()

        let samples = [200, 201, 250, 280, 299]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .success([]), when: {
                let emptyListJson = Data(makeItemsJson([]))
                client.complete(withStatusCode: code, data: emptyListJson, at: index)
            })
        }
    }

    func test_load_deliversItemsOn2xxHTTPResponseWithJsonItems() {
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

        let samples = [200, 201, 250, 280, 299]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .success(items), when: {
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }

    func test_load_doesNotDeliverResultAfterSUTHasBeenDeallocated() {
        let client = HTTPClientSpy()
        let url = URL(string: "https://a-given-url.com")!
        var sut: RemoteImageCommentsLoader? = RemoteImageCommentsLoader(url: url, client: client)

        var capturedResults = [RemoteImageCommentsLoader.Result]()
        sut?.load { capturedResults.append($0) }

        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJson([]))

        XCTAssertTrue(capturedResults.isEmpty)
    }

    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteImageCommentsLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteImageCommentsLoader(url: url, client: client)
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(sut)
        return (sut, client)
    }

    private func failure(_ error: APIError) -> RemoteImageCommentsLoader.Result {
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

    private func expect(_ sut: RemoteImageCommentsLoader, toCompleteWith expectedResult: RemoteImageCommentsLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
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
