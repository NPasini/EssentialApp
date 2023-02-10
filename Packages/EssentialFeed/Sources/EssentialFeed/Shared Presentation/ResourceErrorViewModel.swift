//
//  ResourceErrorViewModel.swift
//  
//
//  Created by Nicolò Pasini on 24/07/22.
//

import Foundation

public struct ResourceErrorViewModel {

    public let errorMessage: String?

    static var noError: ResourceErrorViewModel {
        ResourceErrorViewModel(errorMessage: nil)
    }

    static func error(message: String) -> ResourceErrorViewModel {
        ResourceErrorViewModel(errorMessage: message)
    }
}
