//
//  BooksViewController.swift
//  mahanenko.ru
//
//  Created by norlin on 06/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//


import UIKit
import CoreData

class BooksViewController: ItemsCollectionViewController, NSFetchedResultsControllerDelegate {
    override var log:Log { return Log(id: "BooksViewController") }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Book")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
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
        log.debug("titleHeight \(textHeight)+\(cellSize)")
        
        collectionViewLayout
        
        return CGSize(width: cellSize, height: cellSize+textHeight)
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
