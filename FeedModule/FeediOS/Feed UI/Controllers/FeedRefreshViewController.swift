//
//  FeedRefreshViewController.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/19/22.
//

import UIKit

final class FeedRefreshViewController: NSObject, FeedLoadingView {

    private let loadFeed: () -> Void

    internal init(loadFeed: @escaping () -> Void) {
        self.loadFeed = loadFeed
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
        loadFeed()
    }
    
}
