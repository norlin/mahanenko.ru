//
//  BooksViewController.swift
//  mahanenko.ru
//
//  Created by norlin on 06/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//


import UIKit

class BooksViewController: ItemsCollectionViewController {
    override var log:Log { return Log(id: "BooksViewController") }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BookCell", forIndexPath: indexPath) as! BookCellView
        
        let item = selected[indexPath.row] as! Book
        cell.configure(item)
        
        return cell
    }
    
    
    func update(completion: ()->Void) {
        api.getBooksList(){result, error in
            self.items = result
            dispatch_async(dispatch_get_main_queue()){
                completion()
                
                self.updateFilter()
                self.setFilter(nil)
            }
        }

    }

    func pullRefresh(sender: UIRefreshControl) {
        log.notice("refresh")
        update(){
            sender.endRefreshing()
        }
    }
    
    override func refresh(sender: AnyObject) {
        log.notice("refresh")
        if let refreshControl = sender as? UIRefreshControl {
            return pullRefresh(refreshControl)
        }
        
        self.loader.startAnimating()
        update(){
            self.loader.stopAnimating()
        }
    }
}
