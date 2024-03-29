//
//  FeedItemsMapper.swift
//  
//
//  Created by Nicolò Pasini on 08/06/22.
//

import Foundation

public enum FeedItemsMapper {
    
    private struct Root: Decodable {
        private let items: [RemoteFeedItem]
        
        private struct RemoteFeedItem: Decodable {
            let id: UUID
            let description: String?
            let location: String?
            let image: URL
        }
        
        var images: [FeedImage] {
            items.map { FeedImage(id: $0.id, url: $0.image, location: $0.location, description: $0.description) }
        }
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [FeedImage] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw APIError.invalidData
        }
        
        return root.images
    }
}
