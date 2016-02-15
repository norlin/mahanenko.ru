//
//  ItemsListFilter.swift
//  mahanenko.ru
//
//  Created by norlin on 07/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

protocol ItemsFilterDelegate {

    var items: [FilterableItem]? { get set }
    var selectedType: String! { get set }

    func getTypeName(type: String?) -> String
    func updateFilter()
    func setFilter(type: String?)
    func createHandler(type: String?) -> ((action: UIAlertAction) -> Void)
    func showFilter(vc: UIViewController, sender: AnyObject)
    func dismissFilter(action: UIAlertAction)
}

// Items Filter
class ItemsFilter: ItemsFilterDelegate {
    let log = Log(id: "ItemsFilter")
    let api = SiteAPI.sharedInstance()
    var items: [FilterableItem]?
    
    var filterOptions: UIAlertController?
    var selectedType: String!
    var onSetFilter: ((selected: [FilterableItem], type: String)->Void)!
    
    init(onSetFilter: (selected: [FilterableItem], type: String)->Void){
        self.onSetFilter = onSetFilter
    }
    
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
        var selected: [FilterableItem]
        guard let items = self.items else {
            selected = []
            return
        }
        if let type = type {
            selected = items.filter { return $0.filter(type) }
        } else {
            selected = items
        }
        
        onSetFilter(selected: selected, type: selectedType)
    }
    
    func createHandler(type: String?) -> ((action: UIAlertAction) -> Void) {
        return {(action: UIAlertAction) in
            self.setFilter(type)
            self.dismissFilter(action)
        }
    }
    
    func showFilter(vc: UIViewController, sender: AnyObject) {
        guard let filter = filterOptions else {
            return
        }
        
        vc.presentViewController(filter, animated: true, completion: nil)
    }
    
    func dismissFilter(action: UIAlertAction) {
        guard let filter = filterOptions else {
            return
        }
        
        filter.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

