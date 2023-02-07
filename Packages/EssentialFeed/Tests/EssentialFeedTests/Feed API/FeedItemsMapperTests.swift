//
//  FeedItemsMapperTests.swift
//  
//
//  Created by Nicolò Pasini on 03/06/22.
//

import XCTest
import TestUtilities
import EssentialFeed

class FeedItemsMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HttpResponse() throws {
        let json = makeItemsJson([])
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_throwsErrorOn200HTTPResponseWithInvalidJson() throws {
        let invalidJson = Data("invalid json".utf8)

        XCTAssertThrowsError(
            try FeedItemsMapper.map(invalidJson, from: HTTPURLResponse(statusCode: 200))
        )
    }

    func test_map_throwsErrorOn200HTTPResponseWithPartiallyValidJSONItems() throws {
        let validItem = makeItem(
            id: UUID(),
            imageURL: URL(string: "http://another-url.com")!
        ).json
        let invalidItem = ["invalid": "item"]
        let items = [validItem, invalidItem]
        let json = makeItemsJson(items)

        XCTAssertThrowsError(
            try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        )
    }

    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJsonList() throws {
        let emptyListJson = Data(makeItemsJson([]))
        
        let result = try FeedItemsMapper.map(emptyListJson, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }

    func test_map_deliversItemsOn200HTTPResponseWithJsonItems() throws {
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

        let result = try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }

    // MARK: - Helpers

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
}

private extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
