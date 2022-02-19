//
//  UIControl+TestHelpers.swift
//  FeediOSTests
//
//  Created by Omran Khoja on 2/19/22.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
