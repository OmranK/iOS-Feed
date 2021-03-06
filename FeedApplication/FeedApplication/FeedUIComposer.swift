//
//  FeedUIComposer.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/19/22.
//

import UIKit
import FeedCoreModule
import FeedPresentationModule
import FeediOS

final public class FeedUIComposer {
    private init() {}
    
    // MARK: - Composition with Combine Framework + universal abstractions
    
    public static func feedControllerComposedWith(
        feedLoader: @escaping () -> FeedLoader.Publisher,
        imageLoader: @escaping (URL) -> ImageLoader.Publisher) -> FeedViewController {
        
        let presentationAdapter = FeedLoadingPresentationAdapter(
            feedLoader: { feedLoader().dispatchOnMainQueue() })
        
        let feedController = FeedViewController.makeWith(
            delegate: presentationAdapter,
            title: FeedPresenter.title)
        
        let presenter = FeedPresenter(
            feedView:  FeedViewAdapter(
                feedController: feedController,
                imageLoader: { imageLoader($0).dispatchOnMainQueue() }),
            loadingView: WeakRefVirtualProxy(feedController),
            errorView: WeakRefVirtualProxy(feedController))
        
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

extension FeedUIComposer {
    
    // MARK: - Composition with Design Patterns
    
//    public static func feedControllerComposedWith(feedLoader: FeedLoader, imageLoader: ImageLoader) -> FeedViewController {
//        let presentationAdapter = FeedLoadingPresentationAdapter(feedLoader: MainQueueDispatchDecorator(decoratee: feedLoader))
//        let feedController = FeedViewController.makeWith(delegate: presentationAdapter, title: FeedPresenter.title)
//
//        let presenter = FeedPresenter(
//            feedView:  FeedViewAdapter(feedController: feedController, imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)),
//            loadingView: WeakRefVirtualProxy(feedController),
//            errorView: WeakRefVirtualProxy(feedController))
//
//        presentationAdapter.presenter = presenter
//
//        return feedController
//    }
    
}


