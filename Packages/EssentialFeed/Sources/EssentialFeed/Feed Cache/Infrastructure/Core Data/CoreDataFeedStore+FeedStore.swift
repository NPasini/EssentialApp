//
//  CoreDataFeedStore+FeedStore.swift
//  
//
//  Created by Nicolò Pasini on 09/08/22.
//

import Foundation

extension CoreDataFeedStore: FeedStore {
    
    public struct CoreDataError: Error {}
    
    public func retrieve() throws -> CachedFeed? {
        try performSync { context in
            Result {
                try ManagedCache.find(in: context).map {
                    CachedFeed(feed: $0.localFeed, timestamp: $0.timestamp)
                }
            }
        }
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        try performSync { context in
            Result {
                do {
                    let managedCache = try ManagedCache.newUniqueInstance(in: context)
                    managedCache.timestamp = timestamp
                    managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
                    
                    try context.save()
                } catch {
                    context.rollback()
                    throw CoreDataError()
                }
            }
        }
    }
    
    public func deleteCachedFeed() throws {
        try performSync { context in
            Result {
                do {
                    try ManagedCache.deleteCache(in: context)
                } catch {
                    context.rollback()
                    throw CoreDataError()
                }
            }
        }
    }
}
