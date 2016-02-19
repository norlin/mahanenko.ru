//
//  ItemsListTable.swift
//  mahanenko.ru
//
//  Created by norlin on 07/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

// UITableViewDataSource
extension ItemsListViewController {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
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
     
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        log.warning("heightForRowAtIndexPath is not defined")
        
        if indexPath.section < items.count {
            return ROW_HEIGHT + IMAGE_HEIGHT + 300
        }
        
        return 41
    }
        
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section < items.count {
            return
        }
        
        //tableView.reloadData()
    }
    
    func refresh(sender: AnyObject) {
        log.warning("refresh is not defined")
    }
}
