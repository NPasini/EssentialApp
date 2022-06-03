//
//  FeedLoader.swift
//  
//
//  Created by Nicolò Pasini on 03/06/22.
//

import Foundation

protocol FeedLoader {
    typealias FeedLoadResult = Result<[FeedItem], Error>
    
    func load(completion: @escaping (FeedLoadResult) -> Void)
}
