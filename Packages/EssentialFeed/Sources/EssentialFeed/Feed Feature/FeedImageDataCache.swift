//
//  FeedImageDataCache.swift
//  
//
//  Created by Nicolò Pasini on 20/09/22.
//

import Foundation

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
