//
//  CoreDataHelpers.swift
//  FeedModule
//
//  Created by Omran Khoja on 2/15/22.
//

import CoreData

internal extension NSPersistentContainer {
    enum LoadingError: Swift.Error {
        case modelNotFound
        case failedToLoadPersistentStores(Swift.Error)
    }
    
    static func load(modelName name: String, url: URL, in bundle: Bundle) throws -> NSPersistentContainer {
        guard let managedObjectModel = NSManagedObjectModel.with(name: name, in: bundle) else { throw LoadingError.modelNotFound }
        let container = NSPersistentContainer(name: name, managedObjectModel: managedObjectModel)
        
        let description = NSPersistentStoreDescription(url: url)
        container.persistentStoreDescriptions = [description]
        
        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw LoadingError.failedToLoadPersistentStores($0) }
        
        return container
    }
}

internal extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0 )}
    }
}
