//
//  Books.swift
//  mahanenko.ru
//
//  Created by norlin on 07/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit
import CoreData

struct BookFull {
    let summary: String!
    let ebookFile: String?
    let freeBookTextId: String?
}

class Book: FilterableItem {
    let log = Log(id: "Book")
    let api = SiteAPI.sharedInstance()
    
    @NSManaged var id: String
    @NSManaged var textId: String?
    @NSManaged var title: String
    @NSManaged var summaryHTML: String
    var summary:NSAttributedString { return self.api.parseHTMLString(summaryHTML)! }
    @NSManaged var image: Image?
    @NSManaged var image3d: Image?
    @NSManaged var date: NSDate?
    @NSManaged var state: String?
    @NSManaged var seria: String?
    @NSManaged var ebookFile: String?
    @NSManaged var freeBookTextId: String?
    @NSManaged var isFull: Bool
    
    override var types: [String] {
        guard let seria = seria else {
            return []
        }
        return [seria]
    }
        
    override func filter(type: String) -> Bool {
        return self.seria == type
    }

    var dateString: String {
        guard let date = date else {
            return ""
        }
        let locale = NSLocale(localeIdentifier: api.localeIdentifier)
        let formatter = NSDateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "dd MMMM yyyy, HH:mm"
        return formatter.stringFromDate(date)
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(id: String, textId: String? = nil, title: String, summary: String, seria: String?, image: String?, image3d: String?, date: NSDate?, state: String?, context: NSManagedObjectContext) {
    
        let entity =  NSEntityDescription.entityForName("Book", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.id = id
        self.textId = textId
        self.title = title
        self.seria = seria
        self.date = date
        self.state = state
        self.summaryHTML = summary
        
        if let image = image {
            self.image = Image(url: image, context: context)
        } else {
            self.image = nil
        }
        
        if let image = image3d {
            self.image3d = Image(url: image, context: context)
        } else {
            self.image3d = nil
        }
    }
    
    func fetchFull(completion:(error: NSError?)->Void){
        log.debug("fetchFull \(self.id)")
        api.getBookItem(self.id) { (result, error) -> Void in
            if error != nil {
                self.log.error("fetchFull error: \(error)")
                completion(error: error)
                return
            }
            
            guard let result = result else {
                self.log.error("fetchFull error: no result found")
                completion(error: NSError(domain: "fetchFull error: no result found", code: 404, userInfo: nil))
                return
            }
            
            self.summaryHTML = result.summary
            self.freeBookTextId = result.freeBookTextId
            self.ebookFile = result.ebookFile
            
            self.isFull = true
            
            CoreDataStackManager.sharedInstance().saveContext()
            completion(error: nil)
        }

    }

}