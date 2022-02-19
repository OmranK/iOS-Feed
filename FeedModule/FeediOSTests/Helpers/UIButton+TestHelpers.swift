//
//  UIButton+TestHelpers.swift
//  FeediOSTests
//
//  Created by Omran Khoja on 2/19/22.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
