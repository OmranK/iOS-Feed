//
//  RemoteFeedLoaderTests.swift
//  FeedModuleTests
//
//  Created by Omran Khoja on 1/24/22.
//

import Foundation
import XCTest

class RemoteFeedLoader {}

class HTTPClient {
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    
}
