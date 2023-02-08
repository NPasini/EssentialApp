//
//  ImageCommentsPresenter.swift
//  
//
//  Created by nicolo.pasini on 08/02/23.
//

import Foundation

import iOSUtilities

public final class ImageCommentsPresenter {

    public static var title: String { Localized.ImageComments.title }

    public static func map(_ feed: [FeedImage]) -> FeedViewModel {
        FeedViewModel(feed: feed)
    }
}
