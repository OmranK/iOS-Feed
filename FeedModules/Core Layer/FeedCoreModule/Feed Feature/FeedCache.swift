//
//  FeedCache.swift
//  FeedCoreModule
//
//  Created by Omran Khoja on 3/13/22.
//

import Foundation

public protocol FeedCache {
    typealias SaveResult = Result<Void, Error>
    func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void)
}
