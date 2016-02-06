//
//  NewsTable.swift
//  mahanenko.ru
//
//  Created by norlin on 26/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

// UITableViewDataSource
extension NewsViewController {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let items = selectedNews else {
            return 0
        }
        return items.count// + 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.alpha = 0
        return view
    }
    
    func getTextHeight(news: News) -> CGFloat {
        let text = UITextView()
        text.attributedText = news.description
        let sizeThatFits = text.sizeThatFits(CGSize(width: tableView.contentSize.width, height: 300))
        return sizeThatFits.height
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section < selectedNews.count {
            let news = selectedNews[indexPath.section]
            let textHeight = getTextHeight(news)
            if news.hasImages {
                return NEWS_ROW_HEIGHT + NEWS_IMAGE_HEIGHT + textHeight
            }
            return NEWS_ROW_HEIGHT + textHeight
        }
        
        return 41
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section < selectedNews.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell", forIndexPath: indexPath) as! NewsCellView
            
            let news = selectedNews[indexPath.section]
            cell.configure(news)
            
            return cell
        }
        
        return tableView.dequeueReusableCellWithIdentifier("MoreCell", forIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section < selectedNews.count {
            return
        }
        
//        cells += 5
        tableView.reloadData()
    }
    
    func refresh(sender: AnyObject) {
        guard let refreshControl = sender as? UIRefreshControl else {
            return
        }
        
        fetcher.getNews(){result, error in
            self.news = result
            dispatch_async(dispatch_get_main_queue()){
                self.updateFilter()
                self.setFilter(nil)
                refreshControl.endRefreshing()
            }
        }
    }
}