//
//  ItemsCollectionViewController.swift
//  mahanenko.ru
//
//  Created by norlin on 10/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit
import CoreData

class ItemsCollectionViewController: UICollectionViewController, DetailViewProtocol {
    var log:Log { return Log(id: "ItemsCollectionViewController") }
    let api = SiteAPI.sharedInstance()
    internal var filterDelegate: ItemsFilter!
    
    var detailItem: MenuItem? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (items.isEmpty) {
            refresh(self)
        }
    }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        log.warning("prepareForSegue is not defined!")
    }
    
    func updateFilter(){
        log.notice("updateFilter")

        self.filterDelegate.updateFilter()
    }
    
    func setFilter(type: String?){
        log.notice("setFilter")
        self.filterDelegate.setFilter(type)
    }
    
    func showFilter(sender: AnyObject){
        filterDelegate.showFilter(self, sender: sender)
    }
    
    func onSetFilter(type: String) {
        log.notice("onSetFilter")
        self.filterButton.title = type
        
        /*let firstRow = NSIndexPath(forRow: 0, inSection: 0)
        collectionView?.reloadData()
        if collectionView?.numberOfItemsInSection(0) > 0 {
            collectionView?.scrollToItemAtIndexPath(firstRow, atScrollPosition: .Top, animated: false)
        }*/
    }
    
    func onDataChanged(inserted: [NSIndexPath], deleted: [NSIndexPath], updated: [NSIndexPath], moved: [[NSIndexPath]]) {
        log.warning("onDataChanged is not defined!")
    }
 
}

