//
//  TableCellView.swift
//  mahanenko.ru
//
//  Created by norlin on 20/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class TableCellView: UITableViewCell {
    func setDefaults(){
        let bgSelectionView = UIView()
        bgSelectionView.backgroundColor = UIColor(netHex: 0xDF473A)
        
        self.selectedBackgroundView = bgSelectionView
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setDefaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setDefaults()
    }
    
}
