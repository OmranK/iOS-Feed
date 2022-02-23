//
//  FeedUIComposer.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/19/22.
//

import FeedCoreModule
import UIKit

final public class FeedUIComposer {
    private init() {}
    
    public static func feedControllerComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let presentationAdapter = FeedLoadingPresentationAdapter(feedLoader: MainQueueDispatchDecorator(decoratee: feedLoader))
        let feedController = FeedViewController.makeWith(delegate: presentationAdapter, title: FeedPresenter.title)
        
        let presenter = FeedPresenter(
            feedView:  FeedViewAdapter(feedController: feedController, imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)),
            loadingView: WeakRefVirtualProxy(feedController),
            loadingErrorView: WeakRefVirtualProxy(feedController))
        
        presentationAdapter.presenter = presenter
        
        return feedController
    }
}


private extension FeedViewController {
    static func makeWith(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.delegate = delegate
        feedController.title = title
        return feedController
    }
}


