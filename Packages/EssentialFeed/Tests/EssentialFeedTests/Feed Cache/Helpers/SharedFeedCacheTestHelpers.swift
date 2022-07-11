//
//  SharedFeedCacheTestHelpers.swift
//  
//
//  Created by Nicolò Pasini on 24/06/22.
//

import Foundation
import TestUtilities
import EssentialFeed

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
