//
//  FeedRefreshViewController.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/19/22.
//

import UIKit

protocol FeedRefreshViewControllerDelegate{
    func didRequestFeedRefresh()
}

final class FeedRefreshViewController: NSObject, FeedLoadingView {

    private let delegate: FeedRefreshViewControllerDelegate

    internal init(delegate: FeedRefreshViewControllerDelegate) {
        self.delegate = delegate
    }

    private(set) lazy var view = loadView()
    
    func display(_ viewModel: FeedLoadingViewModel) {
        viewModel.isLoading ? view.beginRefreshing() : view.endRefreshing()
    }
    
    func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
    
    @objc func refresh() {
        delegate.didRequestFeedRefresh()
    }
    
}
