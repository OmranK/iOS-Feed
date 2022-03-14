//
//  FeedLoaderStub.swift
//  FeedApplicationTests
//
//  Created by Omran Khoja on 3/13/22.
//

import FeedCoreModule

class FeedLoaderStub: FeedLoader {
    
    let result: FeedLoader.Result
    
    internal init(result: FeedLoader.Result) {
        self.result = result
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
