//
//  FeedCachePolicy.swift
//  
//
//  Created by Nicolò Pasini on 24/06/22.
//

import Foundation

enum FeedCachePolicy {

    private static var maxCacheAgeInDays: Int { 7 }
    private static let calendar = Calendar(identifier: .gregorian)

    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
}
