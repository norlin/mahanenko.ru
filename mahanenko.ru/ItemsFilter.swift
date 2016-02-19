//
//  ItemsListFilter.swift
//  mahanenko.ru
//
//  Created by norlin on 07/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit
import CoreData

// Items Filter
class ItemsFilter: NSObject, NSFetchedResultsControllerDelegate {
    let log = Log(id: "ItemsFilter")
    let api = SiteAPI.sharedInstance()
    var items: [FilterableItem] {
        if let objects = self.fetchedResultsController.sections?[0].objects as? [FilterableItem] {
            return objects
        }
        
        log.warning("no objects found?")
        return []
    }
    
    var filterOptions: UIAlertController?
    var selectedType: String!
    var onSetFilter: ((type: String)->Void)!
    
    var entityName: String { return "" }
    
    init(onSetFilter: (type: String)->Void, onDataChanged: (inserted: [NSIndexPath], deleted: [NSIndexPath])->Void){
        super.init()
        self.onSetFilter = onSetFilter
        self.onDataChanged = onDataChanged
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {}
        
        updateFilter()
        log.debug("\(items)")
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
        for item in items {
            types.unionInPlace(item.types)
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
    
    func makePredicate(type: String) -> NSPredicate {
        return NSPredicate(format: "type == %@", type)
    }
    
    func setFilter(type: String?) {
        log.notice("setFilter")
        if type == selectedType {
            return
        }
        
        selectedType = getTypeName(type)
        
        sharedContext.performBlock {
            //NSFetchedResultsController.deleteCacheWithName("cache_\(self.entityName)")
            self.fetchedResultsController.fetchRequest.predicate = self.makePredicate(self.selectedType)
            do {
                try self.fetchedResultsController.performFetch()
            } catch {
                self.log.error("\(error)")
            }
            self.onSetFilter(type: self.selectedType)
        }
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
    
    // CoreData
    var insertedItems = [NSIndexPath]()
    var deletedItems = [NSIndexPath]()
    
    var onDataChanged: ((inserted: [NSIndexPath], deleted: [NSIndexPath])->Void)!
    
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
    
    func controller(controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?) {
        
            log.debug("didChangeObject")
            if let _ = anObject as? FilterableItem {
                switch type {
                case .Insert:
                    insertedItems.append(newIndexPath!)
                case .Delete:
                    deletedItems.append(indexPath!)
                default:
                    break
                }
                log.debug("didChangeObject: done")
                return
            }
            log.debug("didChangeObject: missed")
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        log.debug("controllerDidChangeContent")
        dispatch_async(dispatch_get_main_queue()){
            self.onDataChanged(inserted: self.insertedItems, deleted: self.deletedItems)
            self.insertedItems.removeAll()
            self.deletedItems.removeAll()
            /*self.photosView.performBatchUpdates({
                if (self.deletedItems.count > 0) {
                    self.photosView.deleteItemsAtIndexPaths(self.deletedItems)
                    self.deletedItems.removeAll()
                    self.deleteLabel.hidden = true
                }
            
                if (self.insertedItems.count > 0) {
                    self.photosView.insertItemsAtIndexPaths(self.insertedItems)
                    self.insertedItems.removeAll()
                }
                
                if (self.fetchedResultsController.fetchedObjects?.count > 0) {
                    self.noPhotosHint.hidden = true
                } else if self.loadintHint.hidden {
                        self.noPhotosHint.hidden = false
                }
            }){done in}*/
        }
        
        
    }
    
}

