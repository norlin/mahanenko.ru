//
//  BooksViewController.swift
//  mahanenko.ru
//
//  Created by norlin on 06/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//


import UIKit
import CoreData

class BooksViewController: ItemsCollectionViewController {
    override var log:Log { return Log(id: "BooksViewController") }
    
    override var entityName: String { return "Book" }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        log.notice("prepareForSegue")
        guard let collectionView = self.collectionView else {
            return
        }
        
        if segue.identifier == "bookDetail" {
            let detailController = segue.destinationViewController as! BookDetailController
            if let selectedBooks = collectionView.indexPathsForSelectedItems() {
                let selectedItem = selectedBooks[0]
                let item = selectedItem.item
                detailController.book = (selected as! [Book])[item]
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BookCell", forIndexPath: indexPath) as! BookCellView
        
        let item = selected[indexPath.row] as! Book
        cell.configure(item)
        
        return cell
    }
    
    func getTextHeight(item: FilterableItem, width: CGFloat) -> CGFloat {
        let text = UILabel()
        text.font = Constants.TITLE3_FONT
        text.lineBreakMode = .ByWordWrapping
        text.numberOfLines = 0
        let book = item as! Book
        text.text = book.title
        let sizeThatFits = text.sizeThatFits(CGSize(width: width-CGFloat(Constants.MARGIN*2), height: 300))
        return sizeThatFits.height+CGFloat(Constants.MARGIN*2)
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let viewWidth = collectionView.contentSize.width
        let cellSize = viewWidth / 2
        
        let textHeight = getTextHeight(selected[indexPath.row], width: cellSize)
        
        return CGSize(width: cellSize, height: cellSize+textHeight)
    }
    
    func update(force: Bool = false, completion:()->Void) {
        log.notice("update")
        self.loader.startAnimating()
        if (!force && (self.items == nil || self.items!.isEmpty)) {
            do {
                try fetchedResultsController.performFetch()
            } catch {}
            
            fetchedResultsController.delegate = self
            if let items = fetchedResultsController.sections?[0].objects as? [Book] {
                self.items = items
            }
        }

        if (force || self.items == nil || self.items!.isEmpty) {
            log.debug("update: fetch items")
            api.getBooksList(){result, error in
                self.items = result
                CoreDataStackManager.sharedInstance().saveContext()
                
                dispatch_async(dispatch_get_main_queue()){
                    self.updateFilter()
                    self.setFilter(nil)
                    self.loader.stopAnimating()
                    completion()
                }
            }
        } else {
            log.debug("update: use stored items")
            
            self.updateFilter()
            self.setFilter(nil)
            self.loader.stopAnimating()
            completion()
        }

    }

    func pullRefresh(sender: UIRefreshControl) {
        log.notice("refresh")
        update(true){
            sender.endRefreshing()
        }
    }
    
    override func refresh(sender: AnyObject) {
        log.notice("refresh")
        if let refreshControl = sender as? UIRefreshControl {
            return pullRefresh(refreshControl)
        }
        
        update(){}
    }
}
