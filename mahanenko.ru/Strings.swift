//
//  Strings.swift
//  mahanenko.ru
//
//  Created by norlin on 03/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

extension NSAttributedString {
    func attributedStringWith(font: UIFont) -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self)
        result.setAttributes([NSFontAttributeName: font], range: NSRange(location: 0, length: self.length))
        
        return NSAttributedString(attributedString: result)
    }
}