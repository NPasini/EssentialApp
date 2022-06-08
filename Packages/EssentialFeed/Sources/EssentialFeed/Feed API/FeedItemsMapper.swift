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

        var feed: [FeedItem] {
            items.map { $0.item }
        }
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

    static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(.invalidData)
        }

        return .success(root.feed)
    }
}
