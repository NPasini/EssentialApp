//
//  FeedLoader.swift
//  
//
//  Created by Nicolò Pasini on 03/06/22.
//

import Foundation

public typealias FeedLoadResult = Result<[FeedImage], Error>

public protocol FeedLoader {
    func load(completion: @escaping (FeedLoadResult) -> Void)
}
