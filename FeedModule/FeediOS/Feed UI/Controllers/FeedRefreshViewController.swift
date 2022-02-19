//
//  FeedRefreshViewController.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/19/22.
//

import UIKit
import FeedModule

public final class FeedRefreshViewController: NSObject {

    private let feedLoader: FeedLoader
    
    internal init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    private(set) lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    var onRefresh: (([FeedImage]) -> Void)?
    
    @objc func refresh() {
        view.beginRefreshing()
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onRefresh?(feed)
            }
            self?.view.endRefreshing()
        }
    }
}
