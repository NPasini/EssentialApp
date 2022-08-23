//
//  FeedLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by Nicolò Pasini on 23/08/22.
//

import Foundation
import EssentialFeed

public final class FeedLoaderCacheDecorator: FeedLoader {

    private let cache: FeedCache
    private let decoratee: FeedLoader

    public init(decoratee: FeedLoader, cache: FeedCache) {
        self.cache = cache
        self.decoratee = decoratee
    }

    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            completion(result.map { feed in
                self?.cache.save(feed) { _ in }
                return feed
            })
        }
    }
}
