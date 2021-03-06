//
//  CoreDataStackManager.swift
//  mahanenko.ru
//
//  Created by norlin on 17/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStackManager {
    let log = Log(id: "CoreDataStackManager")
    let api = SiteAPI.sharedInstance()
    
    private var SQLITE_FILE_NAME: String {
        switch api.lang {
        case .Russian:
            return "mahanenko_ru.sqlite"
        case .English:
            return "mahanenko_en.sqlite"
        }
    }
    
    class func sharedInstance() -> CoreDataStackManager {
        struct Static {
            static let ru = CoreDataStackManager()
            static let en = CoreDataStackManager()
        }
        
        let api = SiteAPI.sharedInstance()
    
        switch api.lang {
        case .Russian:
            return Static.ru
        case .English:
            return Static.en
        }
    }
    
    lazy var applicationDocumentsDirectory: NSURL = {
        self.log.notice("applicationDocumentsDirectory")
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        self.log.notice("managedObjectModel")
        
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        self.log.notice("persistentStoreCoordinator")
        
        let coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.SQLITE_FILE_NAME)
        
        self.log.debug("sqlite path: \(url.path!)")
        
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "CoreDataStackManager: persistentStoreCoordinator", code: 9999, userInfo: dict)
            
            self.log.error("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    func fetchItem(name: String, predicate: NSPredicate) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest(entityName: name)
        fetchRequest.predicate = predicate
        
        do {
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                return results[0] as? NSManagedObject
            }
        } catch {}
        return nil
    }

    func saveContext() {
        log.notice("saveContext \(api.langName)")
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                self.log.error("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}