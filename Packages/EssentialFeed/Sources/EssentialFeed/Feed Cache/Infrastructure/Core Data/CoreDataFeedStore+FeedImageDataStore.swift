//
//  CoreDataFeedStore+FeedImageDataStore.swift
//  
//
//  Created by Nicolò Pasini on 09/08/22.
//

import Foundation

extension CoreDataFeedStore: FeedImageDataStore {

    public func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        completion(.success(.none))
    }

    public func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {
    }
}
