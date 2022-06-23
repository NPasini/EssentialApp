//
//  FeedStore.swift
//  
//
//  Created by Nicolò Pasini on 23/06/22.
//

import Foundation

public enum RetrieveCachedFeedResult {
    case empty
    case failure(Error)
    case found(feed: [LocalFeedImage], timestamp: Date)
}

public protocol FeedStore {

    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrieveCachedFeedResult) -> Void

    func retrieve(completion: @escaping RetrievalCompletion)
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
}
