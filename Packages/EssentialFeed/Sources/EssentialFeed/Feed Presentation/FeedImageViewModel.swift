//
//  FeedImageViewModel.swift
//  
//
//  Created by Nicolò Pasini on 24/07/22.
//

import Foundation

public struct FeedImageViewModel {
    public let location: String?
    public let description: String?

    public var hasLocation: Bool {
        return location != nil
    }
}
