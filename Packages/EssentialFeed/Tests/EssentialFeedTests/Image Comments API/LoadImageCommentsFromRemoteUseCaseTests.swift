//
//  LoadImageCommentsFromRemoteUseCaseTests.swift
//  
//
//  Created by nicolo.pasini on 06/02/23.
//

import XCTest
import EssentialFeed

class LoadImageCommentsFromRemoteUseCaseTests: XCTestCase {

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
            message: "a message",
            createdAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"),
            username: "a username"
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
            message: "a message",
            createdAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"),
            username: "a username")

        let item2 = makeItem(
            id: UUID(),
            message: "another message",
            createdAt: (Date(timeIntervalSince1970: 1577881882), "2020-01-01T12:31:22+00:00"),
            username: "another username")


        let items = [item1.model, item2.model]
        let json = makeItemsJson([item1.json, item2.json])

        let samples = [200, 201, 250, 280, 299]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .success(items), when: {
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
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

    private func makeItem(id: UUID, message: String, createdAt: (date: Date, iso8601String: String), username: String) -> (model: ImageComment, json: [String: Any]) {
        let model = ImageComment(id: id, message: message, createdAt: createdAt.date, username: username)
        
        let json: [String: Any] = [
            "id": id.uuidString,
            "message": message,
            "created_at": createdAt.iso8601String,
            "author": [
                "username": username
            ]
        ]

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
