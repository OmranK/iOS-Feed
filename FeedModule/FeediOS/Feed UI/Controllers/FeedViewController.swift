//
//  FeedViewController.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/17/22.
//

import UIKit
import FeedModule

public final class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching {
    
    private var refreshController: FeedRefreshViewController?
    
    var viewModel = [FeedImageCellController]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    convenience init(refreshController: FeedRefreshViewController) {
        self.init()
        self.refreshController = refreshController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        
        refreshControl = refreshController?.view
        refreshController?.refresh()
        
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view()
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            _ =  cellController(forRowAt: indexPath).view()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        return viewModel[indexPath.row]
    
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
}
