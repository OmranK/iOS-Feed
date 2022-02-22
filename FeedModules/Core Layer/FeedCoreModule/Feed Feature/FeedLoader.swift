//
//  FeedLoader.swift
//  FeedCoreModule
//
//  Created by Omran Khoja on 1/24/22.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    func load(completion: @escaping (Result) -> Void)
}
