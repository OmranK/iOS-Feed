//
//  FeedViewControllerTests+Assertions.swift
//  FeediOSTests
//
//  Created by Omran Khoja on 2/19/22.
//

import XCTest
import FeedCoreModule
import FeediOS

// MARK: - Assertion Helpers

extension FeedUIIntegrationTests {
    func assertThat(_ sut: FeedViewController, isRendering feedImage: [FeedImage], file: StaticString = #file, line: UInt = #line) {
        guard sut.numberOfRenderedFeedImageViews() == feedImage.count else {
            return XCTFail("Expected \(feedImage.count) views rendered got \(sut.numberOfRenderedFeedImageViews()) instead", file: file, line: line)
        }
        
        feedImage.enumerated().forEach { index, image in
            assertThat(sut, hasViewRenderCorrectlyFor: image, at: index, file: file, line: line)
        }
    }
    
    func assertThat(_ sut: FeedViewController, hasViewRenderCorrectlyFor feedImage: FeedImage, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.feedImageView(at: index)
        
        guard let cell = view as? FeedImageCell else {
            return XCTFail("Expected \(FeedImageCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        let shouldLocationBeVisible = (feedImage.location != nil)
        
        XCTAssertEqual(cell.isShowingLocation, shouldLocationBeVisible, "Expected `isShowingLocation` to be \(shouldLocationBeVisible) for image view at index (\(index))", file: file, line: line)
        
        XCTAssertEqual(cell.locationText, feedImage.location, "Expected location text to be \(String(describing: feedImage.location)) for image view at index (\(index))", file: file, line: line)
        
        XCTAssertEqual(cell.descriptionText, feedImage.description, "Expected description text to be \(String(describing: feedImage.description)) for image view at index (\(index))", file: file, line: line)
    }
}
