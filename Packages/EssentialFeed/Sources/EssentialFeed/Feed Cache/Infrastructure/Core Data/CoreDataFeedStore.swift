//
//  CoreDataFeedStore.swift
//  
//
//  Created by Nicolò Pasini on 08/07/22.
//

import CoreData

public final class CoreDataFeedStore {

    public static let modelName = "FeedStore"
    public static let model = NSManagedObjectModel(name: modelName, in: Bundle.module)

    private let context: NSManagedObjectContext
    private let container: NSPersistentContainer

    public struct ModelNotFound: Error {
        public let modelName: String
    }

    public init(storeURL: URL) throws {
        guard let model = CoreDataFeedStore.model else {
            throw ModelNotFound(modelName: CoreDataFeedStore.modelName)
        }

        container = try NSPersistentContainer.load(
            name: CoreDataFeedStore.modelName,
            model: model,
            url: storeURL
        )
        context = container.newBackgroundContext()
    }

    deinit {
        cleanUpReferencesToPersistentStores()
    }

    func performAsync(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
    
    func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R {
        let context = self.context
        var result: Result<R, Error>!
        context.performAndWait { result = action(context) }
        return try result.get()
    }

    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
}
