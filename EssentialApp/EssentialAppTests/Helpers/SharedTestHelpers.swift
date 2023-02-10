//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Nicolò Pasini on 22/08/22.
//

import Foundation
import iOSUtilities
import EssentialFeed

var loadError: String {
    Localized.Shared.loadError
}

var feedTitle: String {
    Localized.Feed.title
}

var commentsTitle: String {
    Localized.ImageComments.title
}

func anyNSError() -> NSError {
    NSError(domain: "test", code: 0)
}

func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}

func anyData() -> Data {
    Data("any data".utf8)
}

func uniqueFeed() -> [FeedImage] {
    [FeedImage(id: UUID(), url: anyURL(), location: "any", description: "any")]
}
