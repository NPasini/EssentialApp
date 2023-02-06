//
//  ImageCommentsMapper.swift
//  
//
//  Created by nicolo.pasini on 06/02/23.
//

import Foundation

enum ImageCommentsMapper {

   private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }

    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw APIError.invalidData
        }

        return root.items
    }
}
