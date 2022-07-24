//
//  FeedImage.swift
//  
//
//  Created by Nicolò Pasini on 03/06/22.
//

import Foundation

public struct FeedImage: Hashable {
    
    public let id: UUID
    public let url: URL
    public let location: String?
    public let description: String?

    public init(id: UUID, url: URL, location: String?, description: String?) {
        self.id = id
        self.url = url
        self.location = location
        self.description = description
    }
}
