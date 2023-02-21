//
//  FeedCache.swift
//  
//
//  Created by Nicolò Pasini on 23/08/22.
//

import Foundation

public protocol FeedCache {
    func save(_ feed: [FeedImage]) throws
}
