//
//  LocalImageLoader.swift
//  FeedCoreModule
//
//  Created by Omran Khoja on 3/10/22.
//

import Foundation

public final class LocalImageLoader {
    private final class Task: ImageLoaderTask {
        private var completion: ((ImageLoader.Result) -> Void)?
        
        init(_ completion: @escaping (ImageLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: ImageLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletions()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    public enum Error: Swift.Error {
        case failed
        case notFound
    }
    
    private let store: ImageDataStore
    
    public init(store: ImageDataStore) {
        self.store = store
    }
    
    public func loadImageData(from url: URL, completion: @escaping (ImageLoader.Result) -> Void) -> ImageLoaderTask {
        let task = Task(completion)
        store.retrieve(dataForURL: url) { [weak self] result in
            guard self != nil else { return }
            task.complete(with: result
                            .mapError { _ in Error.failed }
                            .flatMap { data in
                data.map { .success($0) } ?? .failure(Error.notFound)
            })
        }
        return task
    }
}
