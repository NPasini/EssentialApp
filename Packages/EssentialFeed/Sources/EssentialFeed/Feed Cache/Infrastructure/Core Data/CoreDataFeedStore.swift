//
//  CoreDataFeedStore.swift
//  
//
//  Created by Nicolò Pasini on 08/07/22.
//

import CoreData
import Foundation

public final class CoreDataFeedStore: FeedStore {

    private let context: NSManagedObjectContext
    private let container: NSPersistentContainer

    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "FeedStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }

    public func retrieve(completion: @escaping RetrievalCompletion) {
        let context = self.context
        context.perform {
            let request = NSFetchRequest<ManagedCache>(entityName: ManagedCache.entity().name!)
            request.returnsObjectsAsFaults = false
            if let cache = try! context.fetch(request).first {
                completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
            } else {
                completion(.empty)
            }
        }
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        let context = self.context
        context.perform {
            do {
                let managedCache = ManagedCache(context: context)
                managedCache.timestamp = timestamp
                managedCache.feed = ManagedFeedImage.images(from: feed, in: context)

                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }

    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {

    }
}
