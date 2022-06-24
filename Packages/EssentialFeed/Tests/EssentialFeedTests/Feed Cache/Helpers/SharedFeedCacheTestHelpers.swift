//
//  SharedFeedCacheTestHelpers.swift
//  
//
//  Created by Nicolò Pasini on 24/06/22.
//

import Utilities
import Foundation
import EssentialFeed

func uniqueImage() -> FeedImage {
    FeedImage(id: UUID(), url: anyURL(), location: "any", description: "any")
}

func uniqueImageFeed() -> (models: [FeedImage], locals: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let locals = models.map { LocalFeedImage(id: $0.id, url: $0.url, location: $0.location, description: $0.description) }
    return (models, locals)
}

extension Date {

    private var feedCacheMaxAgeInDays: Int { 7 }

    func minusFeedCacheMaxAge() -> Date {
        self.adding(days: -feedCacheMaxAgeInDays)
    }

    private func adding(days: Int) -> Date {
        Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}

extension Date {

    func adding(seconds: TimeInterval) -> Date {
        self + seconds
    }
}
