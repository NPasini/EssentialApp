//
//  FeedErrorViewModel.swift
//  
//
//  Created by Nicolò Pasini on 23/07/22.
//

import Foundation

struct FeedErrorViewModel {

    let errorMessage: String?

    static var noError: FeedErrorViewModel {
        FeedErrorViewModel(errorMessage: nil)
    }

    static func error(message: String) -> FeedErrorViewModel {
        FeedErrorViewModel(errorMessage: message)
    }
}
