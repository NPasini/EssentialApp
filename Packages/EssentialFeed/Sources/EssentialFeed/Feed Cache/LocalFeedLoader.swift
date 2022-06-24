//
//  LocalFeedLoader.swift
//  
//
//  Created by Nicolò Pasini on 23/06/22.
//

import Foundation

public final class LocalFeedLoader {

    public typealias SaveResult = Error?
    public typealias LoadResult = FeedLoadResult

    private let store: FeedStore
    private let currentDate: () -> Date
    private var maxCacheAgeInDays: Int { 7 }
    private let calendar = Calendar(identifier: .gregorian)

    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }

    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }

            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(feed, with: completion)
            }
        }
    }

    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .failure(error):
                completion(.failure(error))

            case let .found(feed, timestamp) where self.validate(timestamp):
                completion(.success(feed.toModels()))

            case .empty, .found:
                completion(.success([]))
            }
        }
    }

    public func validateCache() {
        store.retrieve { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure:
                self.store.deleteCachedFeed() { _ in }

            case let .found(_, timestamp) where !self.validate(timestamp):
                self.store.deleteCachedFeed() { _ in }
                
            case .empty, .found:
                break
            }
        }
    }

    private func cache(_ items: [FeedImage], with completion: @escaping (SaveResult) -> Void) {
        store.insert(items.toLocal(), timestamp: self.currentDate()) { [weak self] error in
            guard self != nil else { return }

            completion(error)
        }
    }

    private func validate(_ timestamp: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return currentDate() < maxCacheAge
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
