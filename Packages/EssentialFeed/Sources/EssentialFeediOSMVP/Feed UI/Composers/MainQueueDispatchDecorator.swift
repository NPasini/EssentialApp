//
//  MainQueueDispatchDecorator.swift
//  
//
//  Created by Nicolò Pasini on 23/07/22.
//

import Foundation
import EssentialFeed

final class MainQueueDispatchDecorator<Object> {

    private let decoratee: Object

    init(decoratee: Object) {
        self.decoratee = decoratee
    }

    func dispatch(_ work: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { work() }
        }

        work()
    }
}

extension MainQueueDispatchDecorator: FeedLoader where Object == FeedLoader {

    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        self.decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
