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
            configureView()
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
            loader.center = view.center
            self.view.addSubview(loader)
        }
            
        navigationItem.rightBarButtonItem = filterButton
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
    
    func setFilter(type: String?, needReload: Bool){
        log.notice("setFilter")
        filterDelegate.setFilter(type, needReload: needReload)
    }
    
    func showFilter(sender: AnyObject){
        filterDelegate.showFilter(self, sender: sender)
    }
    
    func finishUpdate(){
        if let refreshControl = (collectionView as? RefreshCollectionView)?.refreshControl {
            refreshControl.endRefreshing()
        }
        loader.stopAnimating()
        let firstRow = NSIndexPath(forRow: 0, inSection: 0)
        if collectionView?.numberOfItemsInSection(0) > 0 {
            collectionView?.scrollToItemAtIndexPath(firstRow, atScrollPosition: .Top, animated: false)
        }
    }
    
    func onSetFilter(type: String, needReload: Bool) {
        log.notice("onSetFilter")
        filterButton.title = type
        
        if (needReload) {
            collectionView?.reloadData()
            finishUpdate()
        }
    }
    
    func onDataChanged(inserted: [NSIndexPath], deleted: [NSIndexPath], updated: [NSIndexPath], moved: [[NSIndexPath]]) {
        log.warning("onDataChanged is not defined!")
    }
 
}

