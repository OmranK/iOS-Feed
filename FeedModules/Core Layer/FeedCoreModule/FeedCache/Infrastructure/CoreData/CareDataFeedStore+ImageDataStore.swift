//
//  CareDataFeedStore+ImageDataStore.swift
//  FeedCoreModule
//
//  Created by Omran Khoja on 3/10/22.
//

import Foundation

extension CoreDataFeedStore: ImageDataStore {
    
    public func insert(_ data: Data, for url: URL, completion: @escaping (ImageDataStore.InsertionResult) -> Void) {
        perform { context in
            completion(Result {
                let image = try ManagedFeedImage.first(with: url, in: context)
                image?.data = data
                try context.save()
            })
        }
    }
    
    public func retrieve(dataForURL url: URL, completion: @escaping (ImageDataStore.RetrievalResult) -> Void) {
        perform { context in
            completion(Result {
                return try ManagedFeedImage.first(with: url, in: context)?.data
            })
        }
    }
}
