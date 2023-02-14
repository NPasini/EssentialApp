//
//  Paginated.swift
//  
//
//  Created by nicolo.pasini on 14/02/23.
//

import Foundation

public struct Paginated<Item> {
    
    public typealias LoadMoreCompletion = (Result<Self, Error>) -> Void
    
    public let items: [Item]
    public let loadMore: ((@escaping LoadMoreCompletion) -> Void)?
    
    public init(items: [Item], loadMore: ((@escaping Paginated<Item>.LoadMoreCompletion) -> Void)? = nil) {
        self.items = items
        self.loadMore = loadMore
    }
}
