//
//  NewsViewController.swift
//  mahanenko.ru
//
//  Created by norlin on 15/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit
import CoreData

class NewsViewController: ItemsListViewController {
    override var log:Log { return Log(id: "NewsViewController") }
        
    override var ROW_HEIGHT: CGFloat { return 40 }
    override var IMAGE_HEIGHT: CGFloat { return 184 }
    
    override func setFilterDelegate(){
        filterDelegate = NewsFilter(onSetFilter: onSetFilter, onDataChanged: onDataChanged)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        log.notice("prepareForSegue")
        
        if segue.identifier == "newsDetail" {
            let detailController = segue.destinationViewController as! NewsDetailController
            if let selectedRow = tableView.indexPathForSelectedRow {
                let row = selectedRow.section
                detailController.newsId = (items as! [News])[row].objectID
            }
        }
    }
    
    func getTextHeight(item: FilterableItem) -> CGFloat {
        let text = UITextView()
        let news = item as! News
        text.attributedText = news.summary.attributedStringWith(Constants.TEXT_FONT)
        let sizeThatFits = text.sizeThatFits(CGSize(width: tableView.contentSize.width, height: 300))
        return sizeThatFits.height
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section < items.count {
            let news = items[indexPath.section] as! News
            let textHeight = getTextHeight(news)
            if news.previewImage != nil {
                return ROW_HEIGHT + IMAGE_HEIGHT + textHeight
            }
            return ROW_HEIGHT + textHeight
        }
        
        return 41
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section < items.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell", forIndexPath: indexPath) as! NewsCellView
            
            let item = items[indexPath.section] as! News
            cell.configure(item)
            
            return cell
        }
        
        return tableView.dequeueReusableCellWithIdentifier("MoreCell", forIndexPath: indexPath)
    }
    
    func update(force: Bool = false) {
        log.notice("update")
        loader.startAnimating()
        
        if (force || self.items.isEmpty) {
            log.debug("update: fetch items")
            
            //filterDelegate.clear()
            
            api.getNewsList(){result, error in
                self.log.debug("update: done")
                
                self.sharedContext.performBlock(){
                    CoreDataStackManager.sharedInstance().saveContext()
                }
            }
        } else {
            log.debug("update: use stored items")
        }
    }
    
    func pullRefresh(sender: UIRefreshControl){
        update(true)
    }
    
    override func refresh(sender: AnyObject) {
        log.notice("refresh")
        if let refreshControl = sender as? UIRefreshControl {
            return pullRefresh(refreshControl)
        }
        
        tableView.scrollEnabled = false
        update()
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    override func onDataChanged(inserted: [NSIndexPath], deleted: [NSIndexPath], updated: [NSIndexPath], moved: [[NSIndexPath]]) {
        log.notice("onDataChanged")
        
        self.loader.stopAnimating()
        self.tableView.scrollEnabled = true
        
        print("new: \(inserted.count), deleted: \(deleted.count), upd: \(updated.count), moved: \(moved.count), ")

        if (inserted.count == 0 && deleted.count == 0) {
            return
        }
        
        self.setFilter(nil, needReload: false)
        self.updateFilter()
        
        self.tableView.beginUpdates()
        
        let deletedRows:[NSIndexPath] = deleted.map { return NSIndexPath(forRow: 0, inSection: $0.item) }
        self.tableView.deleteRowsAtIndexPaths(deletedRows, withRowAnimation: .None)
        
        let insertedRows:[NSIndexPath] = inserted.map { return NSIndexPath(forRow: 0, inSection: $0.item) }
        self.tableView.insertRowsAtIndexPaths(insertedRows, withRowAnimation: .None)
        
        self.tableView.endUpdates()
        
        if let refreshControl = (self.tableView as? RefreshTableView)?.refreshControl {
            refreshControl.endRefreshing()
        }
        let firstRow = NSIndexPath(forRow: 0, inSection: 0)
        if self.tableView.numberOfSections > 0 {
            self.tableView.scrollToRowAtIndexPath(firstRow, atScrollPosition: .Top, animated: false)
        }

    }
}

