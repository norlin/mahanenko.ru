//
//  NewsViewController.swift
//  mahanenko.ru
//
//  Created by norlin on 15/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class NewsViewController: ItemsListViewController {
    override var log:Log { return Log(id: "NewsViewController") }
    
    override var ROW_HEIGHT: CGFloat { return 40 }
    override var IMAGE_HEIGHT: CGFloat { return 212 }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        log.notice("prepareForSegue")
        
        if segue.identifier == "newsDetail" {
            let detailController = segue.destinationViewController as! NewsDetailController
            if let selectedRow = tableView.indexPathForSelectedRow {
                let row = selectedRow.section
                detailController.news = (selected as! [News])[row]
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
            if news.hasImages {
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
    
    override func refresh(sender: AnyObject) {
        log.notice("refresh")
        api.getNewsList(){result, error in
            self.items = result
            dispatch_async(dispatch_get_main_queue()){
                self.updateFilter()
                self.setFilter(nil)
                if let refreshControl = sender as? UIRefreshControl {
                    refreshControl.endRefreshing()
                }
            }
        }
    }
}

