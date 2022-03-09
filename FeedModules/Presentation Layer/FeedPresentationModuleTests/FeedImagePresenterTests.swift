//
//  FeedImagePresenterTests.swift
//  FeedPresentationModuleTests
//
//  Created by Omran Khoja on 3/9/22.
//

import XCTest
import FeedCoreModule

struct FeedImageViewVM {
    let description: String?
    let location: String?
    let image: Any?
    let isLoading: Bool
    let shouldRetry: Bool
    var hasLocation: Bool {
        return location != nil
    }
}

protocol FeedImageView {
    func display(_ model: FeedImageViewVM)
}

class FeedImagePresenter {
    
    let view: FeedImageView
    
    init(view: FeedImageView) {
        self.view = view
    }
    
    func didStartLoadingImageData(for model: FeedImage){
        view.display(FeedImageViewVM(description: model.description, location: model.location, image: nil, isLoading: true, shouldRetry: false))
    }
}

class FeedImagePresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    
    func test_didStartLoadingImageData_displaysLoadingImage() {
        let (sut, view) = makeSUT()
        let image = uniqueImage()
        
        sut.didStartLoadingImageData(for: image)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.description, image.description)
        XCTAssertEqual(message?.location, image.location)
        XCTAssertEqual(message?.isLoading, true)
        XCTAssertEqual(message?.shouldRetry, false)
        XCTAssertNil(message?.image)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let viewSpy = ViewSpy()
        let sut = FeedImagePresenter(view: viewSpy)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(viewSpy, file: file, line: line)
        return (sut, viewSpy)
    }
    
    private class ViewSpy: FeedImageView {
        
        private(set) var messages = [FeedImageViewVM]()
        
        func display(_ model: FeedImageViewVM) {
            messages.append(model)
        }
    }
}
