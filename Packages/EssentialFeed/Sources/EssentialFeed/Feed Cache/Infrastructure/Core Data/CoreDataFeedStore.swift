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

    public init(bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "FeedStore", in: bundle)
        context = container.newBackgroundContext()
    }

    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {

    }

    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {

    }
}
