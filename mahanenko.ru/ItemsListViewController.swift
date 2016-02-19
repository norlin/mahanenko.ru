//
//  ItemsListViewController.swift
//  mahanenko.ru
//
//  Created by norlin on 07/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit
import CoreData

class ItemsListViewController: UITableViewController, DetailViewProtocol {
    var log:Log { return Log(id: "ItemsListViewController") }
    let sizer = Sizer.sharedInstance()
    let api = SiteAPI.sharedInstance()
    internal var filterDelegate: ItemsFilter!
    
    var ROW_HEIGHT:CGFloat { return 40 }
    var IMAGE_HEIGHT:CGFloat { return 184 }
    
    var detailItem: MenuItem? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    var loader: Loader!
    
    func setFilterDelegate(){
        filterDelegate = ItemsFilter(onSetFilter: onSetFilter, onDataChanged: onDataChanged)
    }
    
    internal func configureView(){
        log.notice("configureView")
        
        if filterDelegate == nil {
            setFilterDelegate()
            filterButton = UIBarButtonItem(title: filterDelegate.getTypeName(nil), style: .Plain, target: self, action: "showFilter:")
        }
        
        if loader == nil {
            loader = Loader(activityIndicatorStyle: .WhiteLarge)
            loader.center = self.view.center
            self.view.addSubview(loader)
        }
            
        self.navigationItem.rightBarButtonItem = filterButton
    }

    var items: [FilterableItem] { return filterDelegate.items }
    var filterButton: UIBarButtonItem!

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
        
        self.view.bringSubviewToFront(loader)
//        self.loader.startAnimating()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (items.isEmpty) {
            refresh(self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        log.warning("prepareForSegue is not defined!")
    }
    
    func updateFilter(){
        self.filterDelegate.updateFilter()
    }
    
    func setFilter(type: String?){
        self.filterDelegate.setFilter(type)
    }
    
    func showFilter(sender: AnyObject){
        filterDelegate.showFilter(self, sender: sender)
    }
    
    func onSetFilter(type: String) {
        self.filterButton.title = type
        
        let firstRow = NSIndexPath(forRow: 0, inSection: 0)
        tableView.reloadData()
        if tableView.numberOfSections > 0 {
            tableView.scrollToRowAtIndexPath(firstRow, atScrollPosition: .Top, animated: false)
        }
    }
        
    func onDataChanged(inserted: [NSIndexPath], deleted: [NSIndexPath]) {
        log.warning("prepareForSegue is not defined!")
    }
 
}
