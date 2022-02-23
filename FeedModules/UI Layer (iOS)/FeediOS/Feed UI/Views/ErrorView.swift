//
//  ErrorView.swift
//  FeediOS
//
//  Created by Omran Khoja on 2/23/22.
//

import UIKit

public final class ErrorView: UIView {
    @IBOutlet private var button: UIButton!
    
    public var message: String? {
        get { return isVisible ? button.title(for: .normal) : nil }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        button.setTitle(nil, for: .normal)
        alpha = 0
    }
    
    private var isVisible: Bool {
        return alpha > 0
    }
    
    func show(_ message: String?) {
        button.setTitle(message, for: .normal)
        
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
    
    @IBAction private func hideMessageAnimated() {
        UIView.animate(
            withDuration: 0.25,
            animations: { self.alpha = 0 },
            completion: { completed in
                if completed { self.button.setTitle(nil, for: .normal) }
            })
    }
}
