//
//  FeedPresenter.swift
//  
//
//  Created by Nicolò Pasini on 24/07/22.
//

import Foundation
import iOSUtilities

public final class FeedPresenter {

    public static var title: String { Localized.Feed.title }

    public static func map(_ feed: [FeedImage]) -> FeedViewModel {
        FeedViewModel(feed: feed)
    }
}
