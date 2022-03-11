//
//  LoaderSpy+TestHelper.swift
//  FeediOSTests
//
//  Created by Omran Khoja on 2/19/22.
//

import FeedCoreModule
import FeediOS
import Foundation

class LoaderSpy: FeedLoader, ImageLoader {
    
    // MARK: - Feed Loader
    
    private var loadFeedRequests = [(FeedLoader.Result) -> Void]()
    
    var loadFeedCallCount: Int {
        return loadFeedRequests.count
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        loadFeedRequests.append(completion)
    }
    
    func completeLoadingFeed(with feed: [FeedImage] = [], at index: Int = 0) {
        loadFeedRequests[index](.success(feed))
    }
    
    func completeLoadingFeedWithError(at index: Int) {
        let error = NSError(domain: "an error", code: 0)
        loadFeedRequests[index](.failure(error))
    }
    
    // MARK: - FeedImageDataLoader

    private struct TaskSpy: ImageLoaderTask {
        let cancelCallback: () -> Void
        func cancel() {
            cancelCallback()
        }
    }
    
    private var imageRequests = [(url: URL, completion: (ImageLoader.Result) -> Void)]()

    var loadedImageURLs: [URL] {
        return imageRequests.map { $0.url }
    }
    
    private(set) var cancelledImageURLs = [URL]()
    
    func loadImageData(from url: URL, completion: @escaping (ImageLoader.Result) -> Void) -> ImageLoaderTask {
        imageRequests.append((url, completion))
        return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
    }
    
    func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
        imageRequests[index].completion(.success(imageData))
    }
    
    func completeImageLoadingWithError(at index: Int) {
        let error = NSError(domain: "an error", code: 0)
        imageRequests[index].completion(.failure(error))
    }
}
