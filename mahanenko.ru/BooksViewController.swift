//
//  BooksViewController.swift
//  mahanenko.ru
//
//  Created by norlin on 06/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//


import UIKit

class BooksViewController: ItemsListViewController {
    override var log:Log { return Log(id: "BooksViewController") }

    override var ROW_HEIGHT: CGFloat { return 40 }
    override var IMAGE_HEIGHT: CGFloat { return 212 }

    func getTextHeight(item: FilterableItem) -> CGFloat {
        let text = UITextView()
        let news = item as! Book
        text.attributedText = news.summary
        let sizeThatFits = text.sizeThatFits(CGSize(width: tableView.contentSize.width, height: 300))
        return sizeThatFits.height
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section < selected.count {
            let book = selected[indexPath.section] as! Book
            let textHeight = getTextHeight(book)
            return ROW_HEIGHT + IMAGE_HEIGHT + textHeight
        }
        
        return 41
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section < selected.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("BookCell", forIndexPath: indexPath) as! BookCellView
            
            let item = selected[indexPath.section] as! Book
            cell.configure(item)
            
            return cell
        }
        
        return tableView.dequeueReusableCellWithIdentifier("MoreCell", forIndexPath: indexPath)
    }

    override func refresh(sender: AnyObject) {
        api.getBooksList(){result, error in
            self.log.debug("\(result), \(error)")
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
