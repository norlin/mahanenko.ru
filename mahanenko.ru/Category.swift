//
//  Category.swift
//  mahanenko.ru
//
//  Created by norlin on 17/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var parent: Set<News>
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(name: String, context: NSManagedObjectContext){
        let entity =  NSEntityDescription.entityForName("Category", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.name = name
    }
}