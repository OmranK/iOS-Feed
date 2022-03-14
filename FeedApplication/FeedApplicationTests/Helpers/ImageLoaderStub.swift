//
//  FeedLoaderStub.swift
//  FeedApplicationTests
//
//  Created by Omran Khoja on 3/13/22.
//

import Foundation
import FeedCoreModule

class ImageLoaderSpy: ImageLoader {
    private struct Task: ImageLoaderTask {
        let callback: () -> Void
        func cancel() { callback() }
    }
    
    private var loadRequests = [(url: URL, completion: (ImageLoader.Result) -> Void )]()
    var loadedURLs: [URL] {  return loadRequests.map { $0.url } }
    private(set) var cancelledURLs = [URL]()
    
    func loadImageData(from url: URL, completion: @escaping (ImageLoader.Result) -> Void) -> ImageLoaderTask {
        loadRequests.append((url, completion))
        return Task { [weak self] in
            self?.cancelledURLs.append(url)
        }
    }
    
    func complete(with error: Error, at index: Int = 0) {
        loadRequests[index].completion(.failure(error))
    }
    
    func complete(with data: Data, at index: Int = 0) {
        loadRequests[index].completion(.success(data))
    }
}
