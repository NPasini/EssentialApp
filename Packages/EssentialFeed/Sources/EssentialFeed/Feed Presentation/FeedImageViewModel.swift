//
//  FeedImageViewModel.swift
//  
//
//  Created by Nicolò Pasini on 24/07/22.
//

import Foundation

public struct FeedImageViewModel<Image> {
    public let image: Image?
    public let isLoading: Bool
    public let location: String?
    public let shouldRetry: Bool
    public let description: String?

    public var hasLocation: Bool {
        return location != nil
    }
}
