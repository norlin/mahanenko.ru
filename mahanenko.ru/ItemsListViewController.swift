//
//  ItemsListViewController.swift
//  mahanenko.ru
//
//  Created by norlin on 07/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit
import CoreData

class ItemsListViewController: UITableViewController, DetailViewProtocol, NSFetchedResultsControllerDelegate {
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
    
    var loader: Loader!
    
    internal func configureView(){
        log.notice("configureView")
        
        if filterDelegate == nil {
            filterDelegate = ItemsFilter(onSetFilter: onSetFilter)
            filterButton = UIBarButtonItem(title: filterDelegate.getTypeName(nil), style: .Plain, target: self, action: "showFilter:")
        }
        
        if loader == nil {
            loader = Loader(activityIndicatorStyle: .WhiteLarge)
            loader.center = self.view.center
            self.view.addSubview(loader)
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
        
        self.view.bringSubviewToFront(loader)
        
        let imageHeight = sizer.getScale(CGSize(width: 326, height: 184), byWidth: tableView.frame.width).height
        tableView.rowHeight = ROW_HEIGHT + imageHeight
        
        do {
            try fetchedResultsController.performFetch()
        } catch {}
        
        fetchedResultsController.delegate = self
        if let items = fetchedResultsController.sections?[0].objects as? [FilterableItem] {
            self.items = items
        }
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
    
    // CoreData
    var entityName: String { return "" }
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        if (self.entityName=="") {
            self.log.critical("fetchedResultsController: no entity name!")
        }
        let fetchRequest = NSFetchRequest(entityName: self.entityName)
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
    }()

 
}
