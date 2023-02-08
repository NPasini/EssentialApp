//
//  FeedImagePresenter.swift
//  
//
//  Created by Nicolò Pasini on 24/07/22.
//

import Foundation

public final class FeedImagePresenter {

    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(location: image.location, description: image.description)
    }
}
