//
//  ManagedCache.swift
//  
//
//  Created by Nicolò Pasini on 10/07/22.
//

import CoreData
import Foundation

class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet
}
