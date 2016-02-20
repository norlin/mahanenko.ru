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
    
    override func setFilterDelegate(){
        filterDelegate = BookFilter(onSetFilter: onSetFilter, onDataChanged: onDataChanged)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        log.notice("prepareForSegue")
        
        if segue.identifier == "bookDetail" {
            guard let collectionView = self.collectionView else {
                return
            }
            let detailController = segue.destinationViewController as! BookDetailController
            if let selectedBooks = collectionView.indexPathsForSelectedItems() {
                let selectedItem = selectedBooks[0]
                let item = selectedItem.item
                detailController.book = (items as! [Book])[item]
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BookCell", forIndexPath: indexPath) as! BookCellView
        
        let item = items[indexPath.row] as! Book
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
        let viewWidth = collectionView.frame.size.width
        let cellSize = viewWidth / 2
        
        let textHeight = getTextHeight(items[indexPath.row], width: cellSize)
        
        return CGSize(width: cellSize, height: cellSize+textHeight)
    }
    
    func update(force: Bool = false) {
        log.notice("update")

        if (force || self.items.isEmpty) {
            log.debug("update: fetch items")
            
            api.getBooksList(){result, error in
                self.sharedContext.performBlock(){
                    CoreDataStackManager.sharedInstance().saveContext()
                }
            }
        } else {
            log.debug("update: use stored items")
        }

    }

    func pullRefresh(sender: UIRefreshControl) {
        log.notice("pullRefresh")
        update(true)
    }
    
    override func refresh(sender: AnyObject) {
        log.notice("refresh")
        if let refreshControl = sender as? UIRefreshControl {
            return pullRefresh(refreshControl)
        }
        
        self.loader.startAnimating()
        update()
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    override func onDataChanged(inserted: [NSIndexPath], deleted: [NSIndexPath], updated: [NSIndexPath], moved: [[NSIndexPath]]) {
        log.notice("onDataChanged")

        if (inserted.isEmpty && deleted.isEmpty && updated.isEmpty && moved.isEmpty) {
            self.finishUpdate()
            return
        }
        
        print("new: \(inserted.count), deleted: \(deleted.count), upd: \(updated.count), moved: \(moved.count), ")

        setFilter(nil, needReload: false)
        updateFilter()
        
        if let collection = self.collectionView {
            self.collectionView?.performBatchUpdates({
                if (deleted.count > 0) {
                    collection.deleteItemsAtIndexPaths(deleted)
                }
            
                if (inserted.count > 0) {
                    collection.insertItemsAtIndexPaths(inserted)
                }
                
                if (updated.count > 0) {
                    collection.reloadItemsAtIndexPaths(updated)
                }
                
                if (moved.count > 0) {
                    for move in moved {
                        collection.moveItemAtIndexPath(move[0], toIndexPath: move[1])
                    }
                }
            }){done in
                self.finishUpdate()
            }
        }
    }
}
