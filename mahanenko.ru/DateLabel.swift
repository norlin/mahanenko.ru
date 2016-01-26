//
//  DateLabel.swift
//  mahanenko.ru
//
//  Created by norlin on 26/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class NewsDateLabel: UILabel {
    override func drawTextInRect(rect: CGRect) {
        var left: CGFloat = 8
        var right: CGFloat = 8
        if let superview = self.superview {
            left = superview.layoutMargins.left
            right = superview.layoutMargins.right
        }
        
        let insets = UIEdgeInsets(top: 0, left: left, bottom: 0, right: right)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
}
