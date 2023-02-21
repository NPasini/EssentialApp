//
//  FeedStore.swift
//  
//
//  Created by Nicolò Pasini on 23/06/22.
//

import Foundation

public typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)

public protocol FeedStore {
    func deleteCachedFeed() throws
    func retrieve() throws -> CachedFeed?
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws
}
