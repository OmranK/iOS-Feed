//
//  FeedLoader.swift
//  FeedModule
//
//  Created by Omran Khoja on 1/24/22.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
