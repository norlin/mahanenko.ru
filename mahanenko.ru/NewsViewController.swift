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

    override func setFilterDelegate(){
        filterDelegate = NewsFilter(onSetFilter: onSetFilter, onDataChanged: onDataChanged)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        log.notice("prepareForSegue")
        
        if segue.identifier == "newsDetail" {
            let detailController = segue.destinationViewController as! NewsDetailController
            if let selected = tableView.indexPathForSelectedRow {
                let item = filterDelegate.fetchedResultsController.objectAtIndexPath(selected)
                detailController.newsId = (item as! News).objectID
            }
        }
    }
    
    func update(force: Bool = false) {
        log.notice("update")
        
        //if (force || self.items.isEmpty) {
            log.debug("update: fetch items")
            
            api.getNewsList(){result, error in
                self.log.debug("update: done")
                if error != nil {
                    self.finishUpdate()
                    AlertViewController.showAlert(self, message: NSLocalizedString("Something goes wrong while fetching news\n\nPlease try to refresh the list", comment: "News fetching error"))
                }
                
                self.sharedContext.performBlock(){
                    CoreDataStackManager.sharedInstance().saveContext()
                }
            }
        //} else {
        //    log.debug("update: use stored items")
        //}
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
        loader.startAnimating()
        update()
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    override func onDataChanged(inserted: [NSIndexPath], deleted: [NSIndexPath], updated: [NSIndexPath], moved: [[NSIndexPath]]) {
        log.debug("onDataChanged")

        if (inserted.count == 0 && deleted.count == 0) {
            finishUpdate()
            return
        }
        
        tableView.beginUpdates()
        
        self.tableView.deleteRowsAtIndexPaths(deleted, withRowAnimation: .None)
        tableView.insertRowsAtIndexPaths(inserted, withRowAnimation: .None)
        
        tableView.endUpdates()
        
        setFilter(nil, needReload: false)
        finishUpdate()
    }
}

extension NewsViewController {
    func getTextHeight(item: FilterableItem) -> CGFloat {
        let text = UITextView()
        let news = item as! News
        text.attributedText = news.getSummary().attributedStringWith(Constants.TEXT_FONT)
        let sizeThatFits = text.sizeThatFits(CGSize(width: tableView.contentSize.width, height: 500))
        return sizeThatFits.height
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let news = filterDelegate.fetchedResultsController.objectAtIndexPath(indexPath) as! News
        let textHeight = getTextHeight(news)
        let horizontalClass = self.traitCollection.horizontalSizeClass
        let verticalClass = self.traitCollection.verticalSizeClass
        let wideIphone = horizontalClass == .Regular && verticalClass == .Compact
        
        if (!wideIphone && (horizontalClass == .Regular || verticalClass == .Compact)) {
            let imageHeight = sizer.getScale(CGSize(width: 326, height: 184), byWidth: tableView.contentSize.width * 0.3).height
            let maxHeight = max(textHeight, imageHeight)
            return ROW_HEIGHT + maxHeight
        } else {
            if news.previewImage != nil {
                let imageHeight = sizer.getScale(CGSize(width: 326, height: 184), byWidth: tableView.contentSize.width).height
                return ROW_HEIGHT + imageHeight + textHeight
            }
            return ROW_HEIGHT + textHeight
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = filterDelegate.fetchedResultsController.objectAtIndexPath(indexPath) as! News
        let cellId = item.previewImage == nil ? "NewsCellText" : "NewsCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! NewsCellView
        cell.configure(item)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("newsDetail", sender: self)
    }
}

