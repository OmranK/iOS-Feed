//
//  CareDataFeedStore+ImageDataStore.swift
//  FeedCoreModule
//
//  Created by Omran Khoja on 3/10/22.
//

import Foundation

extension CoreDataFeedStore: ImageDataStore {

    public func insert(_ data: Data, for url: URL, completion: @escaping (ImageDataStore.InsertionResult) -> Void) {

    }

    public func retrieve(dataForURL url: URL, completion: @escaping (ImageDataStore.RetrievalResult) -> Void) {
        completion(.success(.none))
    }
}
