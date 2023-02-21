//
//  LocalFeedLoader.swift
//  
//
//  Created by Nicolò Pasini on 23/06/22.
//

import Foundation

public final class LocalFeedLoader {

    private let store: FeedStore
    private let currentDate: () -> Date

    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalFeedLoader: FeedCache {

    public typealias SaveResult = FeedCache.Result

    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        completion(SaveResult {
            try store.deleteCachedFeed()
            try store.insert(feed.toLocal(), timestamp: currentDate())
        })
    }
}

extension LocalFeedLoader {

    public typealias LoadResult = Result<[FeedImage], Error>

    public func load(completion: @escaping (LoadResult) -> Void) {
        completion(LoadResult {
            if let cache = try store.retrieve(), FeedCachePolicy.validate(cache.timestamp, against: currentDate()) {
                return cache.feed.toModels()
            }
            
            return []
        })
    }
}

extension LocalFeedLoader {

    public typealias ValidationResult = Result<Void, Error>

    private struct InvalidCache: Error {}
    
    public func validateCache(completion: @escaping (ValidationResult) -> Void) {
        completion(ValidationResult {
            do {
                if let cache = try store.retrieve(), !FeedCachePolicy.validate(cache.timestamp, against: currentDate()) {
                    throw InvalidCache()
                }
            } catch {
                try store.deleteCachedFeed()
            }
        })
    }
}

private extension Array where Element == FeedImage {

    func toLocal() -> [LocalFeedImage] {
        map { LocalFeedImage(id: $0.id, url: $0.url, location: $0.location, description: $0.description) }
    }
}

private extension Array where Element == LocalFeedImage {

    func toModels() -> [FeedImage] {
        map { FeedImage(id: $0.id, url: $0.url, location: $0.location, description: $0.description) }
    }
}
