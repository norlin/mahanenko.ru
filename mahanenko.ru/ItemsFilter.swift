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
    
    var filterOptions: UIAlertController?
    var selectedType: String!
    var onSetFilter: ((type: String, needReload: Bool)->Void)!
    
    var entityName: String { return "" }
    
    init(onSetFilter: (type: String, needReload: Bool)->Void, onDataChanged: ((inserted: [NSIndexPath], deleted: [NSIndexPath], updated: [NSIndexPath], moved: [[NSIndexPath]])->Void)){
        super.init()
        self.onSetFilter = onSetFilter
        self.onDataChanged = onDataChanged
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {}
        
        updateFilter()
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
        
        filterOptions = UIAlertController(title: NSLocalizedString("Select category", comment: "Items filter title"), message: "", preferredStyle: .ActionSheet)
        filterOptions?.modalPresentationStyle = .Popover
        var types = Set<String>()
        for item in fetchedResultsController.fetchedObjects as! [FilterableItem] {
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
    
    func setFilter(type: String?, needReload: Bool) {
        log.notice("setFilter")
        if type == selectedType {
            return
        }
        
        selectedType = getTypeName(type)
        
        sharedContext.performBlock {
            self.fetchedResultsController.fetchRequest.predicate = type == nil ? nil : self.makePredicate(self.selectedType)
            do {
                try self.fetchedResultsController.performFetch()
            } catch {
                self.log.error("\(error)")
            }
            self.onSetFilter(type: self.selectedType, needReload: needReload)
            if type == nil {
                self.updateFilter()
            }
        }
    }
    
    func createHandler(type: String?) -> ((action: UIAlertAction) -> Void) {
        return {(action: UIAlertAction) in
            self.setFilter(type, needReload: true)
            self.dismissFilter(action)
        }
    }
    
    func showFilter(vc: UIViewController, sender: AnyObject) {
        guard let filter = filterOptions else {
            return
        }

        let presenter = filterOptions?.popoverPresentationController
        if let barButton = sender as? UIBarButtonItem {
            presenter?.barButtonItem = barButton
        } else {
            presenter?.sourceView = vc.view
        }
        vc.presentViewController(filter, animated: true, completion: nil)
    }
    
    func dismissFilter(action: UIAlertAction) {
        guard let filter = filterOptions else {
            return
        }
        
        filter.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Helpers
    
    func clear(){
        sharedContext.performBlockAndWait(){
            self.fetchedResultsController.fetchRequest.predicate = nil
            do {
                try self.fetchedResultsController.performFetch()
            } catch {}
            
            if let objects = self.fetchedResultsController.fetchedObjects as? [NSManagedObject] {
                for object in objects {
                    self.sharedContext.deleteObject(object)
                }
            }
        }
    }
    
    // CoreData
    var insertedItems = [NSIndexPath]()
    var deletedItems = [NSIndexPath]()
    var updatedItems = [NSIndexPath]()
    var movedItems = [[NSIndexPath]]()
    
    var onDataChanged: ((inserted: [NSIndexPath], deleted: [NSIndexPath], updated: [NSIndexPath], moved: [[NSIndexPath]])->Void)!
    
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
        
            if let _ = anObject as? FilterableItem {
                switch type {
                case .Insert:
                    insertedItems.append(newIndexPath!)
                case .Delete:
                    deletedItems.append(indexPath!)
                case .Update:
                    updatedItems.append(indexPath!)
                case .Move:
                    movedItems.append([indexPath!, newIndexPath!])
                }
                return
            }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        dispatch_async(dispatch_get_main_queue()){
            self.onDataChanged(inserted: self.insertedItems, deleted: self.deletedItems, updated: self.updatedItems, moved: self.movedItems)
            self.insertedItems.removeAll()
            self.deletedItems.removeAll()
            self.updatedItems.removeAll()
            self.movedItems.removeAll()
        }
        
        
    }
    
}

