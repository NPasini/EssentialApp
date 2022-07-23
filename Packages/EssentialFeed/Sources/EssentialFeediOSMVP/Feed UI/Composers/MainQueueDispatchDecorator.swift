//
//  MainQueueDispatchDecorator.swift
//  
//
//  Created by Nicolò Pasini on 23/07/22.
//

import Foundation
import EssentialFeed

final class MainQueueDispatchDecorator: FeedLoader {

    private let decoratee: FeedLoader

    init(decoratee: FeedLoader) {
        self.decoratee = decoratee
    }

    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        self.decoratee.load { result in
            if Thread.isMainThread {
                completion(result)
            } else {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
}
