//
//  CoreDataStackManager.swift
//  mahanenko.ru
//
//  Created by norlin on 17/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import Foundation
import CoreData

private let SQLITE_FILE_NAME = "mahanenko.sqlite"

class CoreDataStackManager {
    let log = Log(id: "CoreDataStackManager")
    
    class func sharedInstance() -> CoreDataStackManager {
        struct Static {
            static let instance = CoreDataStackManager()
        }
    
        return Static.instance
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

}