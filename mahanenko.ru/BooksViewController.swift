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
                let item = filterDelegate.fetchedResultsController.objectAtIndexPath(selectedItem)
                detailController.book = (item as! Book)
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BookCell", forIndexPath: indexPath) as! BookCellView
        
        let item = filterDelegate.fetchedResultsController.objectAtIndexPath(indexPath) as! Book
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
        guard let layout = collectionViewLayout as? ItemsCollectionFlowLayout else {
            return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: indexPath)
        }
        
        let defaultSize = layout.itemSize
        let item = filterDelegate.fetchedResultsController.objectAtIndexPath(indexPath) as! Book
        let textHeight = getTextHeight(item, width: defaultSize.width)
        
        return CGSize(width: defaultSize.width, height: defaultSize.height+textHeight)
    }
    
    func updateCollectionCellSize(size: CGSize){
        guard let collectionView = self.collectionView else {
            return
        }

        guard let layout = collectionView.collectionViewLayout as? ItemsCollectionFlowLayout else {
            return
        }
        
        log.debug("updateCollectionCellSize")

        let viewWidth = size.width
        let cellsInRow = Int(floor(viewWidth / CGFloat(160)))
        let cellsCount = max(2, cellsInRow)
        let cellSize = CGFloat(floor(viewWidth / CGFloat(cellsCount)))
        
        layout.itemSize = CGSize(width: cellSize, height: cellSize)

        layout.invalidateLayout()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let collectionView = self.collectionView else {
            return
        }

        updateCollectionCellSize(collectionView.frame.size)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        updateCollectionCellSize(size)
    }
    
    func update(force: Bool = false) {
        log.notice("update")

        //if (force || self.items.isEmpty) {
            log.debug("update: fetch items")
            
            api.getBooksList(){result, error in
                if error != nil {
                    self.finishUpdate()
                    AlertViewController.showAlert(self, message: NSLocalizedString("Something goes wrong while fetching books\n\nPlease try to refresh the list", comment: "Books fetching error"))
                }
                self.sharedContext.performBlock(){
                    CoreDataStackManager.sharedInstance().saveContext()
                }
            }
        //} else {
        //    log.debug("update: use stored items")
        //}

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
