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
