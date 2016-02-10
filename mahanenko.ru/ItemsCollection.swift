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
        log.debug("sizeForItemAtIndexPath 1")
        let viewWidth = collectionView.contentSize.width
        log.debug("sizeForItemAtIndexPath 2")
        let cellSize = viewWidth / 2
        
        log.debug("sizeForItemAtIndexPath 3")
        return CGSize(width: cellSize, height: cellSize+21)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        log.debug("numberOfItemsInSection 1")
        guard let items = selected else {
            log.debug("numberOfItemsInSection 1.1")
            return 0
        }
        log.debug("numberOfItemsInSection 2 \(items.count)")
        return items.count
    }

    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        log.debug("didSelectItemAtIndexPath 1")
        if indexPath.row < selected.count {
            return
        }
        
        //collectionView.reloadData()
    }
    
    func refresh(sender: AnyObject) {
        log.warning("refresh is not defined")
    }
}
