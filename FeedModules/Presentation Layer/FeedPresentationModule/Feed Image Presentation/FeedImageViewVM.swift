//
//  FeedImageViewVM.swift
//  FeedCoreModule
//
//  Created by Omran Khoja on 3/9/22.
//

public struct FeedImageViewVM<Image> {
    public let description: String?
    public let location: String?
    public let image: Image?
    public let isLoading: Bool
    public let shouldRetry: Bool
    public var hasLocation: Bool {
        return location != nil
    }
}
