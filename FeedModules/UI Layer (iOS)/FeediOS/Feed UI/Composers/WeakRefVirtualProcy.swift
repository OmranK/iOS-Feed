//
//  WeakRefVirtualProcy.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/22/22.
//

import UIKit
import FeedPresentationModule

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?

    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewVM) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: FeedImageView where T: FeedImageView, T.Image == UIImage {
    typealias Image = T.Image
    
    func display(_ model: ImageViewModel<Image>) {
        object?.display(model)
    }
}


extension WeakRefVirtualProxy: FeedLoadingErrorView where T: FeedLoadingErrorView {
    func display(_ model: FeedLoadingErrorViewVM) {
        object?.display(model)
    }
}
