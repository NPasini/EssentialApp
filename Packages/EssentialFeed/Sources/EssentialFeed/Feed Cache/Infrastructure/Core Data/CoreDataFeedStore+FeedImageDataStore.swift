//
//  CoreDataFeedStore+FeedImageDataStore.swift
//  
//
//  Created by Nicolò Pasini on 09/08/22.
//

import Foundation

extension CoreDataFeedStore: FeedImageDataStore {

    public func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        perform { context in
            completion(Result {
                try ManagedFeedImage.data(with: url, in: context)
            })
        }
    }

    public func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {
        perform { context in
            completion(Result {
                try ManagedFeedImage.first(with: url, in: context)
                    .map { $0.data = data }
                    .map(context.save)
            })
        }
    }
}
