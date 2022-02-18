
//
//  FeedViewControllerTests.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/17/22.
//

import XCTest
import UIKit
import FeedModule
import FeediOS

final class FeedViewControllerTests: XCTestCase {
    
    func test_loadFeedActions_requestsFeedFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadFeedCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadFeedCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadFeedCallCount, 2, "Expected another loading request when user initiates a load")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadFeedCallCount, 3, "Expected a third loading request when user initiates another load")
    }
    
    func test_loadFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true, "Expected a loading indicator when a loading request fires on a view load")
        
        loader.completeLoadingFeed(at: 0)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false, "Expected no loading indicator when a loading request completes successfully")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true, "Expected a loading indicator when a loading request fires after the user initiates a load")
        
        loader.completeLoadingFeedWithError(at: 1)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false, "Expected no loading indicator when a loading request completes with an error")
    }
    
    func test_loadFeedCompletion_rendersSuccessfullyLoadedFeed() {
        let (sut, loader) = makeSUT()
        
        let image0 = makeImage(description: "a description", location: "a location")
        let image1 = makeImage(description: "a description", location: nil)
        let image2 = makeImage(description: nil, location: "a location")
        let image3 = makeImage(description: nil, location: nil)
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeLoadingFeed(with: [image0], at: 0)
        assertThat(sut, isRendering: [image0])
        
        sut.simulateUserInitiatedFeedReload()
        loader.completeLoadingFeed(with: [image0, image1, image2, image3], at: 1)
        assertThat(sut, isRendering: [image0, image1, image2, image3])
    }
    
    func test_loadFeedCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let (sut, loader) = makeSUT()
        let image = makeImage()
        
        sut.loadViewIfNeeded()
        loader.completeLoadingFeed(with: [image], at: 0)
        assertThat(sut, isRendering: [image])
        
        sut.simulateUserInitiatedFeedReload()
        loader.completeLoadingFeedWithError(at: 1)
        assertThat(sut, isRendering: [image])
    }
    
    func test_feedImageView_loadsImageURLWhenVisible() {
        let (sut, loader) = makeSUT()
        let image0 = makeImage(url: URL(string: "http://url-0.com")!)
        let image1 = makeImage(url: URL(string: "http://url-1.com")!)
        
        sut.loadViewIfNeeded()
        loader.completeLoadingFeed(with: [image0, image1], at: 0)
        XCTAssertEqual(loader.loadedImageURLS, [], "Expected no image URL requests until views become visible")
        
        sut.simulateVisibleImageView(at: 0)
        XCTAssertEqual(loader.loadedImageURLS, [image0.url], "Expected no image URL requests until views become visible")
        
        sut.simulateVisibleImageView(at: 1)
        XCTAssertEqual(loader.loadedImageURLS, [image0.url, image1.url], "Expected no image URL requests until views become visible")
    }
    
    func test_feedImageView_cancelsLoadingImageURLWhenNotVisible() {
        let (sut, loader) = makeSUT()
        let image0 = makeImage(url: URL(string: "http://url-0.com")!)
        let image1 = makeImage(url: URL(string: "http://url-1.com")!)
        
        sut.loadViewIfNeeded()
        loader.completeLoadingFeed(with: [image0, image1], at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [], "Expected no image URL requests until views become visible")
        
        sut.simulateNotVisibleImageView(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [image0.url], "Expected no image URL requests until views become visible")
        
        sut.simulateNotVisibleImageView(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [image0.url, image1.url], "Expected no image URL requests until views become visible")

    }
    
    // MARK: - Make Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(feedLoader: loader, imageLoader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func makeImage(description: String? = nil, location: String? = nil, url: URL = URL(string: "http://any-url.com")!) -> FeedImage {
        return FeedImage(id: UUID(), description: description, location: location, url: url)
    }
    
    // MARK: - Assertion Helpers
    
    private func assertThat(_ sut: FeedViewController, isRendering feedImage: [FeedImage], file: StaticString = #file, line: UInt = #line) {
        guard sut.numberOfRenderedFeedImageViews() == feedImage.count else {
            return XCTFail("Expected \(feedImage.count) views rendered got \(sut.numberOfRenderedFeedImageViews()) instead", file: file, line: line)
        }
        
        feedImage.enumerated().forEach { index, image in
            assertThat(sut, hasViewRenderCorrectlyFor: image, at: index, file: file, line: line)
        }
    }
    
    private func assertThat(_ sut: FeedViewController, hasViewRenderCorrectlyFor feedImage: FeedImage, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.feedImageView(at: index)
        
        guard let cell = view as? FeedImageCell else {
            return XCTFail("Expected \(FeedImageCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        let shouldLocationBeVisible = (feedImage.location != nil)
        
        XCTAssertEqual(cell.isShowingLocation, shouldLocationBeVisible, "Expected `isShowingLocation` to be \(shouldLocationBeVisible) for image view at index (\(index))", file: file, line: line)
        
        XCTAssertEqual(cell.locationText, feedImage.location, "Expected location text to be \(String(describing: feedImage.location)) for image view at index (\(index))", file: file, line: line)
        
        XCTAssertEqual(cell.descriptionText, feedImage.description, "Expected description text to be \(String(describing: feedImage.description)) for image view at index (\(index))", file: file, line: line)
    }
    
    // MARK: - Spy
    
    class LoaderSpy: FeedLoader, FeedImageDataLoader {
        
        // MARK: - Feed Loader
        
        private var loadFeedRequests = [(FeedLoader.Result) -> Void]()
        
        var loadFeedCallCount: Int {
            return loadFeedRequests.count
        }
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            loadFeedRequests.append(completion)
        }
        
        func completeLoadingFeed(with feed: [FeedImage] = [], at index: Int) {
            loadFeedRequests[index](.success(feed))
        }
        
        func completeLoadingFeedWithError(at index: Int) {
            let error = NSError(domain: "an error", code: 0)
            loadFeedRequests[index](.failure(error))
        }
        
        // MARK: - FeedImageDataLoader

        private struct TaskSpy: FeedImageDataLoaderTask {
            let cancelCallback: () -> Void
            func cancel() {
                cancelCallback()
            }
        }
        
        private(set) var loadedImageURLS = [URL]()
        private(set) var cancelledImageURLs = [URL]()
        
        func loadImageData(from url: URL) -> FeedImageDataLoaderTask {
            loadedImageURLS.append(url)
            return TaskSpy { [weak self] in self?.cance`cledImageURLs.append(url) }
        }
    }
}

// MARK: - DSL Helper Extensions

private extension FeedViewController {
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    func numberOfRenderedFeedImageViews() -> Int {
        return tableView.numberOfRows(inSection: feedImagesSection)
    }
    
    @discardableResult
    func simulateVisibleImageView(at index: Int) -> FeedImageCell {
        return (feedImageView(at: index) as? FeedImageCell)!
    }
    
    func simulateNotVisibleImageView(at row: Int) {
        let view = feedImageView(at: row)
        
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: 0)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
    }
    
    func feedImageView(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    private var feedImagesSection: Int {
        return 0
    }
}

private extension FeedImageCell {
    
    var isShowingLocation: Bool {
        return !locationContainer.isHidden
    }
    var locationText: String? {
        return locationLabel.text
    }
    
    var descriptionText: String? {
        return descriptionLabel.text
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}


