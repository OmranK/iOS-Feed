//
//  FeedLoadingErrorViewModel.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/23/22.
//

struct FeedLoadingErrorViewModel {
    let errorMessage: String?
    
    static var noError: FeedLoadingErrorViewModel {
        return FeedLoadingErrorViewModel(errorMessage: nil)
    }
    
    
    static func error(message: String) -> FeedLoadingErrorViewModel {
        return FeedLoadingErrorViewModel(errorMessage: message)
    }
}
