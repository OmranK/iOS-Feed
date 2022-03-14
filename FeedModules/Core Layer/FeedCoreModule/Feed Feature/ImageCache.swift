//
//  FeedCache.swift
//  FeedCoreModule
//
//  Created by Omran Khoja on 3/13/22.
//

import Foundation

public protocol ImageCache {
    typealias Result = Swift.Result<Void, Error>
    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
