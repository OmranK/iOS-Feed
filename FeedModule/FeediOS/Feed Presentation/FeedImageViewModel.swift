//
//  FeedImageViewModel.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/19/22.
//

import Foundation
import FeedModule

struct ImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    var hasLocation: Bool {
        return location != nil
    }
}
