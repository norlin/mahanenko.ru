//
//  ItemsCollectionViewController.swift
//  mahanenko.ru
//
//  Created by norlin on 10/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class ItemsCollectionViewController: UICollectionViewController, DetailViewProtocol {
    var log:Log { return Log(id: "ItemsCollectionViewController") }
    let sizer = Sizer.sharedInstance()
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
            
        self.navigationItem.rightBarButtonItem = filterButton
        
        refresh(self)
    }

    var items: [FilterableItem]?
    
    var filterButton: UIBarButtonItem!
    var selected: [FilterableItem]!

    override func viewDidLoad() {
        log.notice("viewDidLoad")
        super.viewDidLoad()
        
        if let table = collectionView as? RefreshCollectionView {
            if let refreshControl = table.refreshControl {
                refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
            }
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
        log.notice("onSetFilter")
        self.selected = selected
        self.filterButton.title = type
        log.debug("onSetFilter 1")
        
        let firstRow = NSIndexPath(forRow: 0, inSection: 0)
        log.debug("onSetFilter 2")
        collectionView?.reloadData()
        log.debug("onSetFilter 3")
        if collectionView?.numberOfItemsInSection(0) > 0 {
            log.debug("onSetFilter 4")
            collectionView?.scrollToItemAtIndexPath(firstRow, atScrollPosition: .Top, animated: false)
        }
        log.debug("onSetFilter 5")
    }
 
}

