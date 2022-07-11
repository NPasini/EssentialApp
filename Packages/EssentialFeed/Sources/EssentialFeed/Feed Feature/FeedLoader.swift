//
//  FeedLoader.swift
//  
//
//  Created by Nicolò Pasini on 03/06/22.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>

    func load(completion: @escaping (Result) -> Void)
}
