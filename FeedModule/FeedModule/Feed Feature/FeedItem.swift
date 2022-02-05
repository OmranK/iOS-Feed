//
//  FeedItem.swift
//  FeedModule
//
//  Created by Omran Khoja on 1/24/22.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
