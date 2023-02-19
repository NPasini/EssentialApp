//
//  FeedImageDataLoader.swift
//  
//
//  Created by Nicolò Pasini on 16/07/22.
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
