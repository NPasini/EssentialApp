//
//  FeedErrorViewModel.swift
//  
//
//  Created by Nicolò Pasini on 24/07/22.
//

import Foundation

public struct FeedErrorViewModel {

    public let errorMessage: String?

    static var noError: FeedErrorViewModel {
        FeedErrorViewModel(errorMessage: nil)
    }

    static func error(message: String) -> FeedErrorViewModel {
        FeedErrorViewModel(errorMessage: message)
    }
}
