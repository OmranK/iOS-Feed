//
//  UIRefreshControl+TestHelpers.swift
//  FeediOSTests
//
//  Created by Omran Khoja on 2/19/22.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
