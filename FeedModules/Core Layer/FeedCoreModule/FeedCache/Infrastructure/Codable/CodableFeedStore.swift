//
//  CodableFeedStore.swift
//  FeedCoreModule
//
//  Created by Omran Khoja on 2/10/22.
//

import Foundation

public final class CodableFeedStore: FeedStore {
    
    private struct Cache: Codable {
        let feed: [CodableFeedImage]
        let timestamp: Date
        
        var localFeed: [LocalFeedImage] {
            return feed.map { $0.local }
        }
    }
    
    private struct CodableFeedImage: Codable {
        public let id: UUID
        public let description: String?
        public let location: String?
        public let url: URL
        
        init(_ image: LocalFeedImage) {
            id = image.id
            description = image.description
            location = image.location
            url = image.url
        }
        
        var local: LocalFeedImage {
            return LocalFeedImage(id: id, description: description, location: location, url: url)
        }
    }
    
    private let queue = DispatchQueue(label: "\(CodableFeedStore.self)Queue", qos: .userInitiated, attributes: .concurrent)
    private let storeURL: URL
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        queue.async { [storeURL] in
            completion(Result {
                guard let data = try? Data(contentsOf: storeURL) else {
                    return .none
                }
                let decoder = JSONDecoder()
                let cache = try decoder.decode(Cache.self, from: data)
                return CachedFeed(feed: cache.localFeed, timestamp: cache.timestamp)
            })
        }
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        queue.async(flags: .barrier) { [storeURL] in
            completion(Result {
                let encoder = JSONEncoder()
                let cache = Cache(feed: feed.map(CodableFeedImage.init), timestamp: timestamp)
                let encodedData = try! encoder.encode(cache)
                try encodedData.write(to: storeURL)
            })
        }
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        queue.async(flags: .barrier) { [storeURL] in
            completion(Result {
                guard FileManager.default.fileExists(atPath: storeURL.path) else {
                    return
                }
                try FileManager.default.removeItem(at: storeURL)
            })
        }
    }
}
