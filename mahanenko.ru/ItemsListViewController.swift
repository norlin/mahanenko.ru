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
    let sizer = Sizer.sharedInstance()
    let api = SiteAPI.sharedInstance()
    private var filterDelegate: ItemsFilterDelegate!
    
    var ROW_HEIGHT:CGFloat { return 40 }
    var IMAGE_HEIGHT:CGFloat { return 184 }
    
    var detailItem: MenuItem? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    internal func configureView(){
        log.notice("configureView")
        
        if filterDelegate == nil {
            filterDelegate = ItemsFilter(onSetFilter: onSetFilter)
            filterButton = UIBarButtonItem(title: filterDelegate.getTypeName(nil), style: .Plain, target: self, action: "showFilter:")
        }
            
        self.navigationItem.rightBarButtonItem = filterButton
        
        refresh(self)
    }

    var items: [FilterableItem]?
    
    var filterButton: UIBarButtonItem!
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
    
    func updateFilter(){
        self.filterDelegate.items = items
        self.filterDelegate.updateFilter()
    }
    
    func setFilter(type: String?){
        self.filterDelegate.setFilter(type)
    }
    
    func showFilter(sender: AnyObject){
        filterDelegate.showFilter(self, sender: sender)
    }
    
    func onSetFilter(selected: [FilterableItem], type: String) {
        self.selected = selected
        self.filterButton.title = type
        
        let firstRow = NSIndexPath(forRow: 0, inSection: 0)
        tableView.reloadData()
        if tableView.numberOfSections > 0 {
            tableView.scrollToRowAtIndexPath(firstRow, atScrollPosition: .Top, animated: false)
        }
    }
 
}
