//
//  FeedRefreshViewController.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/19/22.
//

import UIKit

final class FeedRefreshViewController: NSObject, FeedLoadingView {

    private let viewPresenter: FeedPresenter

    internal init(viewPresenter: FeedPresenter) {
        self.viewPresenter = viewPresenter
    }

    private(set) lazy var view = loadView()
    
    func display(isLoading: Bool) {
        isLoading ? view.beginRefreshing() : view.endRefreshing()
    }
    
    func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
    
    @objc func refresh() {
        viewPresenter.loadFeed()
    }
    
}
