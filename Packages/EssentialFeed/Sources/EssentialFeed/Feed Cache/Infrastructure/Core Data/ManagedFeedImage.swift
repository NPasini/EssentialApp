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

    var local: LocalFeedImage {
        LocalFeedImage(id: id, url: url, location: location, description: imageDescription)
    }

    static func images(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        NSOrderedSet(array: localFeed.map { local in
            let managed = ManagedFeedImage(context: context)
            managed.id = local.id
            managed.url = local.url
            managed.location = local.location
            managed.imageDescription = local.description
            return managed
        })
    }
}
