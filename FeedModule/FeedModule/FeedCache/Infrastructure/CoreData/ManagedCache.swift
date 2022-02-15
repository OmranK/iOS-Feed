//
//  ManagedCache.swift
//  FeedModule
//
//  Created by Omran Khoja on 2/15/22.
//

import CoreData

@objc(ManagedCache)
internal class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet
    
    var localFeed: [LocalFeedImage] {
        return feed.compactMap { ($0 as? ManagedFeedImage)?.local}
    }
    
    func managedImageFeed(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localFeed.map { localFeedImage in
            let managedFeedImage = ManagedFeedImage(context: context)
            managedFeedImage.id = localFeedImage.id
            managedFeedImage.imageDescription = localFeedImage.description
            managedFeedImage.location = localFeedImage.location
            managedFeedImage.url = localFeedImage.url
            return managedFeedImage
        })
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
        try find(in: context).map(context.delete)
        return ManagedCache(context: context)
    }
    
    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: ManagedCache.entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
}
