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
}

extension Date {

    func adding(seconds: TimeInterval) -> Date {
        self + seconds
    }
    
    func adding(minutes: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
            return calendar.date(byAdding: .minute, value: minutes, to: self)!
        }
    
    func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }
}
