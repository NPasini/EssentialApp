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
    private let queue: DispatchQueue

    public init(storeURL: URL) {
        self.storeURL = storeURL
        self.queue = DispatchQueue(label: "\(CodableFeedStore.self)_queue", qos: .userInitiated, attributes: .concurrent)
    }

    public func retrieve(completion: @escaping RetrievalCompletion) {
        let storeURL = storeURL
        queue.async {
            guard let data = try? Data(contentsOf: storeURL) else {
                return completion(.success(nil))
            }

            do {
                let decoder = JSONDecoder()
                let cache = try decoder.decode(Cache.self, from: data)
                completion(.success(CachedFeed(feed: cache.localFeed, timestamp: cache.timestamp)))
            } catch {
                completion(.failure(error))
            }
        }
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        let storeURL = storeURL
        queue.async(flags: .barrier) {
            do {
                let encoder = JSONEncoder()
                let cache = Cache(timestamp: timestamp, feed: feed.map(CodableFeedImage.init))
                let encoded = try encoder.encode(cache)
                try encoded.write(to: storeURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }

    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        let storeURL = storeURL
        queue.async(flags: .barrier) {
            let fileManager = FileManager.default
            guard fileManager.fileExists(atPath: storeURL.path) else {
                return completion(nil)
            }

            do {
                try fileManager.removeItem(at: storeURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
