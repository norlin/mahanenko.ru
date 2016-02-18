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
    
    override var entityName: String { return "News" }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        log.notice("prepareForSegue")
        
        if segue.identifier == "newsDetail" {
            let detailController = segue.destinationViewController as! NewsDetailController
            if let selectedRow = tableView.indexPathForSelectedRow {
                let row = selectedRow.section
                detailController.newsId = (selected as! [News])[row].objectID
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
        if indexPath.section < selected.count {
            let news = selected[indexPath.section] as! News
            let textHeight = getTextHeight(news)
            if news.previewImage != nil {
                return ROW_HEIGHT + IMAGE_HEIGHT + textHeight
            }
            return ROW_HEIGHT + textHeight
        }
        
        return 41
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section < selected.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell", forIndexPath: indexPath) as! NewsCellView
            
            let item = selected[indexPath.section] as! News
            cell.configure(item)
            
            return cell
        }
        
        return tableView.dequeueReusableCellWithIdentifier("MoreCell", forIndexPath: indexPath)
    }
    
    func update(force: Bool = false, completion:()->Void) {
        log.notice("update")
        loader.startAnimating()
        if (!force && (self.items == nil || self.items!.isEmpty)){
            log.debug("update: fetch stored items")
            do {
                try fetchedResultsController.performFetch()
            } catch {}
            
            fetchedResultsController.delegate = self
            if let items = fetchedResultsController.sections?[0].objects as? [News] {
                self.items = items
            }
        }
        if (force || self.items == nil || self.items!.isEmpty) {
            log.debug("update: fetch items")
            api.getNewsList(){result, error in
                self.log.debug("update: done")
                self.items = result
                CoreDataStackManager.sharedInstance().saveContext()
                dispatch_async(dispatch_get_main_queue()){
                    self.log.debug("update: completion")
                    self.updateFilter()
                    self.setFilter(nil)
                    self.loader.stopAnimating()
                    completion()
                }
            }
        } else {
            log.debug("update: done")
            self.updateFilter()
            self.setFilter(nil)
            self.loader.stopAnimating()
            completion()
        }
    }
    
    func pullRefresh(sender: UIRefreshControl){
        update(true){
            sender.endRefreshing()
        }
    }
    
    override func refresh(sender: AnyObject) {
        log.notice("refresh")
        if let refreshControl = sender as? UIRefreshControl {
            return pullRefresh(refreshControl)
        }
        
        tableView.scrollEnabled = false
        update(){
            self.tableView.scrollEnabled = true
        }
    }
}

