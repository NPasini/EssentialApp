//
//  FeedItem.swift
//  
//
//  Created by Nicolò Pasini on 03/06/22.
//

import Foundation

public struct FeedItem: Equatable {
    public let id: UUID
    public let imageURL: URL
    public let location: String?
    public let description: String?

    public init(id: UUID, imageURL: URL, location: String?, description: String?) {
        self.id = id
        self.imageURL = imageURL
        self.location = location
        self.description = description
    }
}
