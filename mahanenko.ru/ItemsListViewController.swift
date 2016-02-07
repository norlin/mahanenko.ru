//
//  ItemsListViewController.swift
//  mahanenko.ru
//
//  Created by norlin on 07/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class ItemsListViewController: UITableViewController, DetailViewProtocol {
    var log:Log { return Log(id: "ItemsListViewController") }
    var ROW_HEIGHT:CGFloat { return 40 }
    var IMAGE_HEIGHT:CGFloat { return 184 }
    
    var detailItem: MenuItem? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView(){
        log.notice("configureView")
        
        filterButton = UIBarButtonItem(title: getTypeName(nil), style: .Plain, target: self, action: "showFilter:")
        self.navigationItem.rightBarButtonItem = filterButton
        
        refresh(self)
    }

    let sizer = Sizer.sharedInstance()
    let api = SiteAPI.sharedInstance()
    var items: [FilterableItem]?
    
    var filterButton: UIBarButtonItem!
    var filterOptions: UIAlertController?
    var selectedType: String!
    var selected: [FilterableItem]!

    override func viewDidLoad() {
        log.notice("viewDidLoad")
        super.viewDidLoad()
        
        if let table = tableView as? RefreshTableView {
            if let refreshControl = table.refreshControl {
                refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
            }
        }
        
        let imageHeight = sizer.getScale(CGSize(width: 326, height: 184), byWidth: tableView.frame.width).height
        tableView.rowHeight = ROW_HEIGHT + imageHeight
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        log.warning("prepareForSegue is not defined!")
    }
 
}


