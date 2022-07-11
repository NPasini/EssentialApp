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

extension LocalFeedLoader {

    public typealias SaveResult = Error?

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

    private func cache(_ items: [FeedImage], with completion: @escaping (SaveResult) -> Void) {
        store.insert(items.toLocal(), timestamp: self.currentDate()) { [weak self] error in
            guard self != nil else { return }

            completion(error)
        }
    }
}

extension LocalFeedLoader: FeedLoader {

    public typealias LoadResult = FeedLoader.Result

    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .failure(error):
                completion(.failure(error))

            case let .success(.found(feed, timestamp)) where FeedCachePolicy.validate(timestamp, against: self.currentDate()):
                completion(.success(feed.toModels()))

            case .success:
                completion(.success([]))
            }
        }
    }
}

extension LocalFeedLoader {
    public func validateCache() {
        store.retrieve { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure:
                self.store.deleteCachedFeed() { _ in }

            case let .success(.found(_, timestamp)) where !FeedCachePolicy.validate(timestamp, against: self.currentDate()):
                self.store.deleteCachedFeed() { _ in }

            case .success:
                break
            }
        }
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
