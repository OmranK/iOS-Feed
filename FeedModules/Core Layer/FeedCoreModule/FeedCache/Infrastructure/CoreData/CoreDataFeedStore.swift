//
//  CoreDataFeedStore.swift
//  FeedCoreModule
//
//  Created by Omran Khoja on 2/10/22.
//

import CoreData

public final class CoreDataFeedStore {
    
    private let persistentContainer: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL) throws {
        let bundle = Bundle(for: CoreDataFeedStore.self)
        persistentContainer = try NSPersistentContainer.load(modelName: "FeedStore", url: storeURL, in: bundle)
        context = persistentContainer.newBackgroundContext()
    }
    
    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
}
