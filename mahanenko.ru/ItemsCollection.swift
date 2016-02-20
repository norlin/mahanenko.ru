//
//  ItemsCollection.swift
//  mahanenko.ru
//
//  Created by norlin on 10/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

// UITableViewDataSource
extension ItemsCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let viewWidth = collectionView.contentSize.width
        let cellSize = viewWidth / 2
        
        return CGSize(width: cellSize, height: cellSize+21)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < items.count {
            return
        }
    }
    
    func refresh(sender: AnyObject) {
        log.warning("refresh is not defined")
    }
}
