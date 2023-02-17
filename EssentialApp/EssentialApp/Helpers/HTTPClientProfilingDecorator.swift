//
//  HTTPClientProfilingDecorator.swift
//  EssentialApp
//
//  Created by nicolo.pasini on 16/02/23.
//

import os
import UIKit
import EssentialFeed

class HTTPClientProfilingDecorator: HTTPClient {
    
    private let logger: Logger
    private let decoratee: HTTPClient
    
    init(decoratee: HTTPClient, logger: Logger) {
        self.logger = logger
        self.decoratee = decoratee
    }
    
    func get(from url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) -> HTTPClientTask {
        logger.trace("Started loading URL: \(url)")
        let startTime = CACurrentMediaTime()
        
        return decoratee.get(from: url) { [logger] result in
            if case let .failure(error) = result {
                logger.trace("Failed to load url \(url) with error \(error.localizedDescription)")
            }
            
            let elapsedTime = CACurrentMediaTime() - startTime
            logger.trace("Finished loading URL: \(url) in \(elapsedTime) seconds")
            completion(result)
        }
    }
}
