//
//  CodableFeedStore.swift
//  
//
//  Created by Nicolò Pasini on 06/07/22.
//

import Foundation

public final class CodableFeedStore: FeedStore {

    private struct CodableFeedImage: Codable {
        public let id: UUID
        public let url: URL
        public let location: String?
        public let description: String?

        var local: LocalFeedImage {
            LocalFeedImage(id: id, url: url, location: location, description: description)
        }

        init(_ image: LocalFeedImage) {
            id = image.id
            url = image.url
            location = image.location
            description = image.description
        }
    }

    private struct Cache: Codable {
        let timestamp: Date
        let feed: [CodableFeedImage]

        var localFeed: [LocalFeedImage] {
            feed.map { $0.local }
        }
    }

    private let storeURL: URL

    public init(storeURL: URL) {
        self.storeURL = storeURL
    }

    public func retrieve() throws -> CachedFeed? {
        guard let data = try? Data(contentsOf: storeURL) else {
            return nil
        }

        let decoder = JSONDecoder()
        let cache = try decoder.decode(Cache.self, from: data)
        return CachedFeed(feed: cache.localFeed, timestamp: cache.timestamp)
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        let encoder = JSONEncoder()
        let cache = Cache(timestamp: timestamp, feed: feed.map(CodableFeedImage.init))
        let encoded = try encoder.encode(cache)
        try encoded.write(to: storeURL)
    }

    public func deleteCachedFeed() throws {
        let storeURL = storeURL
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: storeURL.path) {
            try fileManager.removeItem(at: storeURL)
        }
    }
}
