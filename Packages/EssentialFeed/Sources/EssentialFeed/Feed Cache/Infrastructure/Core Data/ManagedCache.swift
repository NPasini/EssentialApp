//
//  ManagedCache.swift
//  
//
//  Created by Nicolò Pasini on 10/07/22.
//

import CoreData
import Foundation

@objc(ManagedCache)
class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet

    var localFeed: [LocalFeedImage] {
        feed.compactMap { ($0 as? ManagedFeedImage)?.local }
    }
}
