//
//  FeedItemsMapper.swift
//  
//
//  Created by Nicolò Pasini on 08/06/22.
//

import Foundation

enum FeedItemsMapper {

    private static var OK_200: Int { 200 }

    private struct Root: Decodable {
        let items: [Item]
    }

    private struct Item: Decodable {
        let id: UUID
        let image: URL
        let location: String?
        let description: String?

        var item: FeedItem {
            FeedItem(id: id, imageURL: image, location: location, description: description)
        }
    }

    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == OK_200 else { throw RemoteFeedLoader.Error.invalidData }
        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.items.map { $0.item }
    }
}
