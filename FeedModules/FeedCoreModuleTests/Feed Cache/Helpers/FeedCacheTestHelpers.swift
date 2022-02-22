//
//  FeedCacheTestHelpers.swift
//  FeedCoreModuleTests
//
//  Created by Omran Khoja on 2/10/22.
//

import Foundation
import FeedCoreModule

internal func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: "any description", location: "any location", url: anyURL())
}

internal func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let local = models.map{ LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    return (models, local)
}

internal extension Date {
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays())
    }
    
    private func feedCacheMaxAgeInDays() -> Int {
        return 7
    }
    
    private func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}

internal extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
