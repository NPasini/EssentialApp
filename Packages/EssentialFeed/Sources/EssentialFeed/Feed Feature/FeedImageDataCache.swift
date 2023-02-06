//
//  FeedImageDataCache.swift
//  
//
//  Created by Nicolò Pasini on 20/09/22.
//

import Foundation

public protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
