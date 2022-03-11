//
//  FeedItemsMapper.swift
//  FeedCoreModule
//
//  Created by Omran Khoja on 2/4/22.
//

import Foundation

internal final class FeedItemsMapper {
    
    private struct Root: Codable {
        let items: [RemoteFeedItem]
    }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return root.items
    }
}
