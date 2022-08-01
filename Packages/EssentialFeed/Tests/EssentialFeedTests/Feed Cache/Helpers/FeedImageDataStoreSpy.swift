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
    private var completions = [(FeedImageDataStore.Result) -> Void]()

    func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.Result) -> Void) {
        completions.append(completion)
        receivedMessages.append(.retrieve(dataFor: url))
    }

    func complete(with error: Error, at index: Int = 0) {
        completions[index](.failure(error))
    }

    func complete(with data: Data?, at index: Int = 0) {
        completions[index](.success(data))
    }

}
