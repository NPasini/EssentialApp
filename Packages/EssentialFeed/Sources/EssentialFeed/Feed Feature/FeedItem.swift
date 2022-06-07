//
//  FeedItem.swift
//  
//
//  Created by Nicolò Pasini on 03/06/22.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let imageURL: URL
    let location: String?
    let description: String?
}
