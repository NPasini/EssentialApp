//
//  FeedImageDataStore.swift
//  
//
//  Created by Nicolò Pasini on 01/08/22.
//

import Foundation

public protocol FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
