//
//  NullStore.swift
//  EssentialApp
//
//  Created by nicolo.pasini on 16/02/23.
//

import Foundation
import EssentialFeed

class NullStore: FeedStore & FeedImageDataStore {
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.success(.none))
    }
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        completion(.success(()))
    }
    
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        completion(.success(()))
    }
    
    func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        completion(.success(.none))
    }
    
    func insert(_ feed: [EssentialFeed.LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        completion(.success(()))
    }
}
