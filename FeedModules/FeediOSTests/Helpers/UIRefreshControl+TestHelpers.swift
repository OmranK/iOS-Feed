//
//  UIRefreshControl+TestHelpers.swift
//  FeediOSTests
//
//  Created by Omran Khoja on 2/19/22.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}
