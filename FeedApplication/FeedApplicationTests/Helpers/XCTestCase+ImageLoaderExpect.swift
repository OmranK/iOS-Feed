//
//  XCTestCase+FeedLoaderExpect.swift
//  FeedApplicationTests
//
//  Created by Omran Khoja on 3/13/22.
//

import FeedCoreModule
import XCTest

protocol ImageLoaderTestCase: XCTestCase { }

extension ImageLoaderTestCase {
    
    func expect(_ sut: ImageLoader, toCompleteWith expectedResult: ImageLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        _ = sut.loadImageData(from: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedImageData), .success(expectedImageData)):
                XCTAssertEqual(receivedImageData, expectedImageData, file: file, line: line)
            case (.failure, .failure):
                break
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 3.0)
    }
}
