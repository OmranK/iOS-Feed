//
//  RemoteFeedItem.swift
//  FeedCoreModule
//
//  Created by Omran Khoja on 2/9/22.
//

import Foundation

internal struct RemoteFeedItem: Codable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
