//
//  UIButton+TestHelpers.swift
//  FeediOSTests
//
//  Created by Omran Khoja on 2/19/22.
//

import UIKit

extension UIButton {
    func simulateTap() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
