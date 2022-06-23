//
//  FeedItemsMapper.swift
//  
//
//  Created by Nicolò Pasini on 08/06/22.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let image: URL
    let location: String?
    let description: String?
}

enum FeedItemsMapper {

    private static var OK_200: Int { 200 }

    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }

    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw APIError.invalidData
        }

        return root.items
    }
}
