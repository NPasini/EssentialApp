//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Nicolò Pasini on 23/08/22.
//

import EssentialFeed

class FeedLoaderStub: FeedLoader {

    private let result: FeedLoader.Result

    init(result: FeedLoader.Result) {
        self.result = result
    }

    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
