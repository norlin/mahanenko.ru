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
        return selectedNews.count + 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.alpha = 0
        return view
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section < selectedNews.count {
            return tableView.rowHeight
        }
        
        return 41
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section < selectedNews.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell", forIndexPath: indexPath) as! NewsCellView
            
            let news = selectedNews[indexPath.section]
            cell.configure(news, index: indexPath.section)
            
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
        tableView.reloadData()
        
        updateFilter()
        
        refreshControl.endRefreshing()
    }
}