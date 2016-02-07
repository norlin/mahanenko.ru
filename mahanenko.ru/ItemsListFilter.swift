//
//  ItemsListFilter.swift
//  mahanenko.ru
//
//  Created by norlin on 07/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

// Items Filter
extension ItemsListViewController {
    
    func getTypeName(type: String?) -> String {
        guard let type = type else {
            switch api.lang {
                case .Russian: return "Все"
                case .English: return "All"
            }
        }
        
        return type
    }
    
    func updateFilter(){
        log.notice("updateFilter")
        if filterOptions != nil {
            filterOptions?.removeFromParentViewController()
            filterOptions = nil
        }
        
        filterOptions = UIAlertController(title: "Select item category", message: "", preferredStyle: .ActionSheet)
        var types = Set<String>()
        if let items = self.items {
            for item in items {
                types.unionInPlace(item.types)
            }
        }

        // create item with type == nil (for "all news", no filter selection)
        filterOptions!.addAction(UIAlertAction(title: getTypeName(nil), style: .Default, handler: createHandler(nil)))
        for type in types {
            let title = getTypeName(type)
            let handler = createHandler(type)
            filterOptions!.addAction(UIAlertAction(title: title, style: .Default, handler: handler))
        }
        
        filterOptions!.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: dismissFilter))

        
    }
    
    func setFilter(type: String?) {
        log.notice("setFilter")
        selectedType = getTypeName(type)
        self.filterButton.title = selectedType
        guard let items = self.items else {
            selected = []
            return
        }
        if let type = type {
            selected = items.filter { return $0.filter(type) }
        } else {
            selected = items
        }
        
        let firstRow = NSIndexPath(forRow: 0, inSection: 0)
        dispatch_async(dispatch_get_main_queue()){
            self.tableView.reloadData()
            if self.tableView.numberOfSections > 0 {
                self.tableView.scrollToRowAtIndexPath(firstRow, atScrollPosition: .Top, animated: false)
            }
        }
    }
    
    func createHandler(type: String?) -> ((action: UIAlertAction) -> Void) {
        return {(action: UIAlertAction) in
            self.setFilter(type)
            self.dismissFilter(action)
        }
    }
    
    func showFilter(sender: AnyObject) {
        guard let filter = filterOptions else {
            return
        }
        
        self.presentViewController(filter, animated: true, completion: nil)
    }
    
    func dismissFilter(action: UIAlertAction) {
        guard let filter = filterOptions else {
            return
        }
        
        filter.dismissViewControllerAnimated(true, completion: nil)
    }
}

