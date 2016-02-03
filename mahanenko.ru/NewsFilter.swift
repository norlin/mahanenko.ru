//
//  NewsFilter.swift
//  mahanenko.ru
//
//  Created by norlin on 26/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

// News Filter
extension NewsViewController {
    
    func getTypeName(type: NewsFilterType) -> String {
        switch (type) {
            case .All: return "All"
            case .Shaman: return "Shaman"
            case .Galaktiona: return "Galaktiona"
        }
    }
    
    func updateFilter(){
        if filterOptions != nil {
            filterOptions?.removeFromParentViewController()
            filterOptions = nil
        }
        
        filterOptions = UIAlertController(title: "Select news category", message: "", preferredStyle: .ActionSheet)
        
        let types:[NewsFilterType] = [.All, .Shaman, .Galaktiona]
        
        for type in types {
            let title = getTypeName(type)
            let handler = createHandler(type)
            filterOptions!.addAction(UIAlertAction(title: title, style: .Default, handler: handler))
        }
        
        filterOptions!.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: dismissFilter))
        
    }
    
    func setFilter(type: NewsFilterType) {
        selectedNewsType = type
        let title = getTypeName(type)
        self.filterButton.title = title
        
        guard let news = self.news else {
            selectedNews = []
            return
        }
        
        if type == .All {
            selectedNews = news
        } else {
            selectedNews = news.filter { return $0.type == type }
        }
        
        dispatch_async(dispatch_get_main_queue()){
            self.tableView.reloadData()
        }
    }
    
    func createHandler(type: NewsFilterType) -> ((action: UIAlertAction) -> Void) {
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
