//
//  NullStore.swift
//  EssentialApp
//
//  Created by nicolo.pasini on 16/02/23.
//

import Foundation
import EssentialFeed

class NullStore: FeedStore & FeedImageDataStore {
    
    func insert(_ data: Data, for url: URL) throws {}

    func retrieve(dataForURL url: URL) throws -> Data? {
        .none
    }
    
    func deleteCachedFeed() throws {}
    
    func retrieve() throws -> CachedFeed? {
        .none
    }
    
    func insert(_ feed: [EssentialFeed.LocalFeedImage], timestamp: Date) throws {}
}
