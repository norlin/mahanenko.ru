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
        if let sections = filterDelegate.fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = filterDelegate.fetchedResultsController.sections {
            return sections[section].numberOfObjects
        }
        
        return 0

    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.alpha = 0
        return view
    }
     
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        log.warning("heightForRowAtIndexPath is not defined")
        
        return ROW_HEIGHT + IMAGE_HEIGHT + 300
    }
    
    func refresh(sender: AnyObject) {
        log.warning("refresh is not defined")
    }
}
