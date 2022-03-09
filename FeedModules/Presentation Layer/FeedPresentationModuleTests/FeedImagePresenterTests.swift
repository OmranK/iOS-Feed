//
//  FeedImagePresenterTests.swift
//  FeedPresentationModuleTests
//
//  Created by Omran Khoja on 3/9/22.
//

import XCTest

struct ImageViewVM {}

protocol FeedImageView {
    func display(_ model: ImageViewVM)
}

class FeedImagePresenter {
    init(view: Any) {
        
    }
}

class FeedImagePresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let viewSpy = ViewSpy()
        let sut = FeedImagePresenter(view: viewSpy)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(viewSpy, file: file, line: line)
        return (sut, viewSpy)
    }
    
    private class ViewSpy {
        
       let messages = [Any]()
    }
}
