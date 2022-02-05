//
//  FeedLoader.swift
//  FeedModule
//
//  Created by Omran Khoja on 1/24/22.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
