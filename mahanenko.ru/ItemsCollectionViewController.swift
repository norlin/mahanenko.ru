//
//  ItemsCollectionViewController.swift
//  mahanenko.ru
//
//  Created by norlin on 10/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit
import CoreData

class ItemsCollectionViewController: UICollectionViewController, DetailViewProtocol, NSFetchedResultsControllerDelegate {
    var log:Log { return Log(id: "ItemsCollectionViewController") }
    let api = SiteAPI.sharedInstance()
    private var filterDelegate: ItemsFilterDelegate!
    
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
        
        if loader == nil {
            loader = Loader(activityIndicatorStyle: .WhiteLarge)
            loader.center = self.view.center
            self.view.addSubview(loader)
        }
            
        self.navigationItem.rightBarButtonItem = filterButton
    }

    var items: [FilterableItem]?
    
    var filterButton: UIBarButtonItem!
    var selected: [FilterableItem]!
    
    var loader: Loader!

    override func viewDidLoad() {
        log.notice("viewDidLoad")
        super.viewDidLoad()
        
        let flowLayout = ItemsCollectionFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        self.collectionView?.collectionViewLayout = flowLayout
        
        if let table = collectionView as? RefreshCollectionView {
            if let refreshControl = table.refreshControl {
                refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
            }
        }

        self.view.bringSubviewToFront(loader)
        self.loader.startAnimating()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (items == nil || items!.isEmpty) {
            refresh(self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        log.warning("prepareForSegue is not defined!")
    }
    
    func updateFilter(){
        log.notice("updateFilter")
        self.filterDelegate.items = items
        self.filterDelegate.updateFilter()
    }
    
    func setFilter(type: String?){
        log.notice("setFilter")
        self.filterDelegate.setFilter(type)
    }
    
    func showFilter(sender: AnyObject){
        filterDelegate.showFilter(self, sender: sender)
    }
    
    func onSetFilter(selected: [FilterableItem], type: String) {
        log.notice("onSetFilter")
        self.selected = selected
        self.filterButton.title = type
        
        let firstRow = NSIndexPath(forRow: 0, inSection: 0)
        collectionView?.reloadData()
        if collectionView?.numberOfItemsInSection(0) > 0 {
            collectionView?.scrollToItemAtIndexPath(firstRow, atScrollPosition: .Top, animated: false)
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

