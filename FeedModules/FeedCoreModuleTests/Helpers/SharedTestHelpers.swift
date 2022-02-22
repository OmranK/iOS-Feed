//
//  SharedTestHelpers.swift
//  FeedCoreModuleTests
//
//  Created by Omran Khoja on 2/10/22.
//

import Foundation

internal func anyURL() -> URL {
    return URL(string: "https://a-given-url.com")!
}

internal func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}
