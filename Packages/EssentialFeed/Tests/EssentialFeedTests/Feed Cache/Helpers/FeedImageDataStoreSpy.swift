//
//  FeedImageDataStoreSpy.swift
//  
//
//  Created by Nicolò Pasini on 01/08/22.
//

import Foundation
import EssentialFeed

class FeedImageDataStoreSpy: FeedImageDataStore {

    enum Message: Equatable {
        case retrieve(dataFor: URL)
        case insert(data: Data, for: URL)
    }

    private(set) var receivedMessages = [Message]()
    private var insertionResult: Result<Void, Error>?
    private var retrievalCompletions = [(FeedImageDataStore.RetrievalResult) -> Void]()

    func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrieve(dataFor: url))
    }

    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }

    func completeRetrieval(with data: Data?, at index: Int = 0) {
        retrievalCompletions[index](.success(data))
    }
    
    func insert(_ data: Data, for url: URL) throws {
        receivedMessages.append(.insert(data: data, for: url))
        try insertionResult?.get()
    }

    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionResult = .failure(error)
    }

    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionResult = .success(())
    }
}
