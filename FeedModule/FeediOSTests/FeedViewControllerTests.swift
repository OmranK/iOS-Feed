
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
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")
        
        sut.simulateVisibleImageView(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [image0.url], "Expected no image URL requests until views become visible")
        
        sut.simulateVisibleImageView(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [image0.url, image1.url], "Expected no image URL requests until views become visible")
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
    
    func test_feedImageViewLoadingIndicator_isVisibleWhileLoadingImage() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeLoadingFeed(with: [makeImage(), makeImage()])
        
        let view0 = sut.simulateVisibleImageView(at: 0)
        let view1 = sut.simulateVisibleImageView(at: 1)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, true, "Expected loading indicator while loading first image")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected loading indicator while loading second image")
        
        loader.completeImageLoading(at: 0)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for the first view once first image loading completes successfully.")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected no loading indicator state change for the second view once first image loading completes successfully.")
        
        
        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator state change for the first view once second image loading completes with error.")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for the second view once second image loading completes with error.")
    }
    
    func test_feedImageView_rendersImageLoadedFromURL() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeLoadingFeed(with: [makeImage(), makeImage()])
        
        let view0 = sut.simulateVisibleImageView(at: 0)
        let view1 = sut.simulateVisibleImageView(at: 1)
        XCTAssertEqual(view0?.renderedImage, .none, "Expected no image for the first view while loading first image.")
        XCTAssertEqual(view1?.renderedImage, .none, "Expected no image for the second view while loading second image.")
        
        let imageData0 = UIImage.make(withColor: .red).pngData()!
        loader.completeImageLoading(with: imageData0, at: 0)
        XCTAssertEqual(view0?.renderedImage, imageData0, "Expected image for the first view once first image loading completes successfully.")
        XCTAssertEqual(view1?.renderedImage, .none, "Expected no image state change for the second view once first image loading completes successfully.")
        
        let imageData1 = UIImage.make(withColor: .blue).pngData()!
        loader.completeImageLoading(with: imageData1, at: 1)
        XCTAssertEqual(view0?.renderedImage, imageData0, "Expected no image state change for the first view once second image loading completes successfully.")
        XCTAssertEqual(view1?.renderedImage, imageData1, "Expected image for the second view once second image loading completes successfully.")
    }
    
    func test_feedImageViewRetryAction_isVisibleOnImageDataLoadError() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeLoadingFeed(with: [makeImage(), makeImage()])
        
        let view0 = sut.simulateVisibleImageView(at: 0)
        let view1 = sut.simulateVisibleImageView(at: 1)
        XCTAssertEqual(view0?.retryActionIsVisible, false, "Expected no retry action for the first view while loading first image.")
        XCTAssertEqual(view1?.retryActionIsVisible, false, "Expected no retry action for the second view while loading second image.")
        
        let imageData = UIImage.make(withColor: .red).pngData()!
        loader.completeImageLoading(with: imageData, at: 0)
        XCTAssertEqual(view0?.retryActionIsVisible, false, "Expected no retry action for the first view once first image loading completes successfully.")
        XCTAssertEqual(view1?.retryActionIsVisible, false, "Expected no retry action state change for the second view once first image loading completes successfully.")
        
        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(view0?.retryActionIsVisible, false, "Expected no retry action state change for the first view once second image loading completes with error.")
        XCTAssertEqual(view1?.retryActionIsVisible, true, "Expected retry action to appear for the second view once second image loading completes with error.")
    }
    
    func test_feedImageViewRetryAction_isVisibleOnInvalidImageData() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeLoadingFeed(with: [makeImage(), makeImage()])
        
        let view = sut.simulateVisibleImageView(at: 0)
        XCTAssertEqual(view?.retryActionIsVisible, false, "Expected no retry action while loading image.")
        
        let invalidImageData = Data("invalid image data".utf8)
        loader.completeImageLoading(with: invalidImageData, at: 0)
        XCTAssertEqual(view?.retryActionIsVisible, true, "Expected retry action to appear when image loading completes with invalid data.")
    }
    
    func test_feedImageViewRetryAction_retriesImageLoad() {
        let (sut, loader) = makeSUT()
        let image0 = makeImage(url: URL(string: "http://url-0.com")!)
        let image1 = makeImage(url: URL(string: "http://url-1.com")!)
        
        sut.loadViewIfNeeded()
        loader.completeLoadingFeed(with: [image0, image1])
        
        let view0 = sut.simulateVisibleImageView(at: 0)
        let view1 = sut.simulateVisibleImageView(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [image0.url, image1.url], "Expected two image URL requests for the two visibile views.")
        
        loader.completeImageLoadingWithError(at: 0)
        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [image0.url, image1.url], "Expected only two image URL requests before retry action.")
        
        view0?.simulateRetryAction()
        XCTAssertEqual(loader.loadedImageURLs, [image0.url, image1.url, image0.url], "Expected three image URL requests after first retry action.")
        
        view1?.simulateRetryAction()
        XCTAssertEqual(loader.loadedImageURLs, [image0.url, image1.url, image0.url, image1.url], "Expected four image URL requests after second retry action.")
    }
    
    func test_feedImageView_preloadsImageURLWhenNearVisible() {
        let (sut, loader) = makeSUT()
        let image0 = makeImage(url: URL(string: "http://url-0.com")!)
        let image1 = makeImage(url: URL(string: "http://url-1.com")!)
        
        sut.loadViewIfNeeded()
        loader.completeLoadingFeed(with: [image0, image1])
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL request until image is near visible.")
        
        sut.simulateImageViewNearVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [image0.url], "Expected first image URL request once first image is near visible.")
        
        sut.simulateImageViewNearVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [image0.url, image1.url], "Expected first and second image URL request once second image is near visible.")

    }
    
    func test_feedImageView_cancelsPreloadINGImageURLWhenNotNearVisibleAnymore() {
        let (sut, loader) = makeSUT()
        let image0 = makeImage(url: URL(string: "http://url-0.com")!)
        let image1 = makeImage(url: URL(string: "http://url-1.com")!)
        
        sut.loadViewIfNeeded()
        loader.completeLoadingFeed(with: [image0, image1])
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL request until image is near visible.")
        
        sut.simulateImageViewNotNearVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [image0.url], "Expected first image URL request once first image is near visible.")
        
        sut.simulateImageViewNotNearVisible(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [image0.url, image1.url], "Expected first and second image URL request once second image is near visible.")

    }
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedUIComposer.feedControllerComposedWith(feedLoader: loader, imageLoader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func makeImage(description: String? = nil, location: String? = nil, url: URL = URL(string: "http://any-url.com")!) -> FeedImage {
        return FeedImage(id: UUID(), description: description, location: location, url: url)
    }
}
