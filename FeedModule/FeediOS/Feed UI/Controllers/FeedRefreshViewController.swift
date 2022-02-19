//
//  FeedRefreshViewController.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/19/22.
//

import UIKit

final class FeedRefreshViewController: NSObject {
    
    private let viewModel: FeedViewModel
    
    internal init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    private(set) lazy var view = binded(UIRefreshControl())
    
    @objc func refresh() {
        viewModel.loadFeed()
    }
    
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onLoadingStateChange = { [weak view] isLoading in
            isLoading ? view?.beginRefreshing() : view?.endRefreshing()
        }
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
