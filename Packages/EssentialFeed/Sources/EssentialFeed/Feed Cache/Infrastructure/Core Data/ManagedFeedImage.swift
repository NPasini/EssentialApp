//
//  ManagedFeedImage.swift
//  
//
//  Created by Nicolò Pasini on 10/07/22.
//

import CoreData
import Foundation

@objc(ManagedFeedImage)
class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var cache: ManagedCache
}
