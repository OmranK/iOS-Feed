//
//  FeedLoadingView.swift
//  FeedCoreModule
//
//  Created by Omran Khoja on 3/9/22.
//

public struct FeedLoadingErrorViewVM {
    public let errorMessage: String?
    
    static var noError: FeedLoadingErrorViewVM {
        return FeedLoadingErrorViewVM(errorMessage: nil)
    }
    
    static func error(message: String) -> FeedLoadingErrorViewVM {
        return FeedLoadingErrorViewVM(errorMessage: message)
    }
}
