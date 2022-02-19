//
//  FeedUIComposer.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/19/22.
//

import FeedModule

public final class FeedUIComposer {
    private init() {}
    
    public static func feedControllerComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let refreshController = FeedRefreshViewController(feedLoader: feedLoader)
        let feedController = FeedViewController(refreshController: refreshController)
        refreshController.onRefresh = { [weak feedController] feed in
            feedController?.viewModel = feed.map { FeedImageCellController(model: $0, imageLoader: imageLoader)}
        }
        return feedController
    }
}
