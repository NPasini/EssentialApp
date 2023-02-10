//
//  ImageCommentsMapperTests.swift
//  
//
//  Created by nicolo.pasini on 06/02/23.
//

import XCTest
import TestUtilities
import EssentialFeed

class ImageCommentsMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon2xxHttpResponse() throws {
        let json = makeItemsJson([])

        let samples = [199, 150, 300, 400, 500]
        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_throwsErrorOn2xxHTTPResponseWithInvalidJson() throws {
        let invalidJson = Data("invalid json".utf8)

        let samples = [200, 201, 250, 280, 299]
        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageCommentsMapper.map(invalidJson, from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_throwsErrorOn2xxHTTPResponseWithPartiallyValidJSONItems() throws {
        let validItem = makeItem(
            id: UUID(),
            message: "a message",
            createdAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"),
            username: "a username"
        ).json

        let invalidItem = ["invalid": "item"]

        let items = [validItem, invalidItem]
        let json = makeItemsJson(items)

        let samples = [200, 201, 250, 280, 299]
        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_deliversNoItemsOn2xxHTTPResponseWithEmptyJsonList() throws {
        let emptyListJson = Data(makeItemsJson([]))

        let samples = [200, 201, 250, 280, 299]
        try samples.forEach { code in
            let result = try ImageCommentsMapper.map(emptyListJson, from: HTTPURLResponse(statusCode: code))
            
            XCTAssertEqual(result, [])
        }
    }

    func test_map_deliversItemsOn2xxHTTPResponseWithJsonItems() throws {
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

        let json = makeItemsJson([item1.json, item2.json])

        let samples = [200, 201, 250, 280, 299]
        try samples.forEach { code in
            let result = try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            
            XCTAssertEqual(result, [item1.model, item2.model])
        }
    }

    // MARK: - Helpers

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
}
