//
//  RemoteFeedItem.swift
//  
//
//  Created by Nicolò Pasini on 23/06/22.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let image: URL
    let location: String?
    let description: String?
}
