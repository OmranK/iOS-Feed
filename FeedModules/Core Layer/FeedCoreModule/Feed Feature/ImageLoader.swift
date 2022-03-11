//
//  FeedImageDataLoader.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/18/22.
//

import Foundation

public protocol ImageLoaderTask {
    func cancel()
}

public protocol ImageLoader {
    typealias Result = Swift.Result<Data, Error>
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> ImageLoaderTask
}
