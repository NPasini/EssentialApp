//
//  SharedTestHelpers.swift
//  
//
//  Created by Nicolò Pasini on 24/06/22.
//

import Foundation
import EssentialFeed

public func anyNSError() -> NSError {
    NSError(domain: "test", code: 0)
}

public func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}

public func anyData() -> Data {
    Data("any data".utf8)
}

public func uniqueImage() -> FeedImage {
    FeedImage(id: UUID(), url: anyURL(), location: "any", description: "any")
}

public func uniqueImageFeed() -> (models: [FeedImage], locals: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let locals = models.map { LocalFeedImage(id: $0.id, url: $0.url, location: $0.location, description: $0.description) }
    return (models, locals)
}
