//
//  CollectionCellView.swift
//  mahanenko.ru
//
//  Created by norlin on 10/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class CollectionCellView: UICollectionViewCell {
    func setDefaults(){
        let bgSelectionView = UIView()
        bgSelectionView.backgroundColor = UIColor(netHex: 0xDF473A)
        
        self.selectedBackgroundView = bgSelectionView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDefaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setDefaults()
    }
    
}