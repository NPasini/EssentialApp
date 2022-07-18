//
//  FeedImageViewModel.swift
//  
//
//  Created by Nicolò Pasini on 19/07/22.
//

import Foundation

struct FeedImageViewModel<Image> {
    let image: Image?
    let isLoading: Bool
    let location: String?
    let shouldRetry: Bool
    let description: String?

    var hasLocation: Bool { location != nil }
}
