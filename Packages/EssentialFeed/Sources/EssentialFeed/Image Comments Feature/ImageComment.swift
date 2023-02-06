//
//  ImageComment.swift
//  
//
//  Created by nicolo.pasini on 06/02/23.
//

import Foundation

public struct ImageComment: Equatable {
    
    public let id: UUID
    public let message: String
    public let createdAt: Date
    public let username: String

    public init(id: UUID, message: String, createdAt: Date, username: String) {
        self.id = id
        self.message = message
        self.username = username
        self.createdAt = createdAt
    }
}
