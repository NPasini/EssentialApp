//
//  FeedStore.swift
//  
//
//  Created by Nicolò Pasini on 23/06/22.
//

import Foundation

public protocol FeedStore {

    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void

    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ items: [LocalFeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
}

// DTO
public struct LocalFeedItem: Equatable {
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
