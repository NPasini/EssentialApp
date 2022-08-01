//
//  FeedImageDataStore.swift
//  
//
//  Created by Nicolò Pasini on 01/08/22.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>

    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
