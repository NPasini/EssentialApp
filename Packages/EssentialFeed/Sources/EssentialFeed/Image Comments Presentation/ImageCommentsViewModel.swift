//
//  ImageCommentsViewModel.swift
//  
//
//  Created by nicolo.pasini on 09/02/23.
//

import Foundation

public struct ImageCommentsViewModel {
    public let comments: [ImageCommentViewModel]
}

public struct ImageCommentViewModel: Equatable, Hashable {
    public let date: String
    public let message: String
    public let username: String
    
    public init(date: String, message: String, username: String) {
        self.date = date
        self.message = message
        self.username = username
    }
}
