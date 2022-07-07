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

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to disptach to approriate threads, if needed.
    func retrieve(completion: @escaping RetrievalCompletion)

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to disptach to approriate threads, if needed.
    func deleteCachedFeed(completion: @escaping DeletionCompletion)

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to disptach to approriate threads, if needed.
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
}
