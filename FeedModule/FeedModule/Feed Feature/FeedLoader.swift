//
//  FeedLoader.swift
//  FeedModule
//
//  Created by Omran Khoja on 1/24/22.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error>

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
