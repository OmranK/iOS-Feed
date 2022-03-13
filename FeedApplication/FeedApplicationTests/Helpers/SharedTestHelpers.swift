//
//  SharedTestHelpers.swift
//  FeedApplicationTests
//
//  Created by Omran Khoja on 3/13/22.
//

import Foundation
import FeedCoreModule

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func uniqueFeed() -> [FeedImage] {
    return [FeedImage(id: UUID(), description: "any description", location: "any location", url: anyURL())]
}
