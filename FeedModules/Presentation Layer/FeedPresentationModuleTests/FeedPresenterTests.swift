//
//  FeedPresenterTests.swift
//  FeedCoreModule
//
//  Created by Omran Khoja on 2/23/22.
//

import XCTest

protocol FeedLoadingErrorView {
    func display(_ viewModel: FeedLoadingErrorViewModel)
}

struct FeedLoadingErrorViewModel {
    let errorMessage: String?
    
    static var noError: FeedLoadingErrorViewModel {
        return FeedLoadingErrorViewModel(errorMessage: nil)
    }
}

final class FeedPresenter {
    
    let errorView: FeedLoadingErrorView
    
    init(errorView: FeedLoadingErrorView) {
        self.errorView = errorView
    }
    
    func didStartLoadingFeed() {
        errorView.display(.noError)
        
    }
}

class FeedPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoadingFeed_displaysNoErrorMessage() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingFeed()
        
        XCTAssertEqual(view.messages, [.display(errorMessage: .none)], "Expected no view messages")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let spy = ViewSpy()
        let sut = FeedPresenter(errorView: spy)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(spy, file: file, line: line)
        return (sut, spy)
    }
    
    private class ViewSpy: FeedLoadingErrorView {
        enum Message: Equatable {
            case display(errorMessage: String?)
        }
        private(set) var messages = [Message]()
        
        func display(_ viewModel: FeedLoadingErrorViewModel) {
            messages.append(.display(errorMessage: viewModel.errorMessage))
        }
    }
    
    
}
