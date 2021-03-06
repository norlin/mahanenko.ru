//
//  News.swift
//  mahanenko.ru
//
//  Created by norlin on 18/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit
import CoreData

struct NewsFull {
    let text: String
    let imageUrls: [String]?
}

class NewsFilter: ItemsFilter {
    override var entityName: String { return "News" }
    
    override func makePredicate(type: String) -> NSPredicate {
        return NSPredicate(format: "ANY category.name == %@", type)
    }
}

class News: FilterableItem {
    let log = Log(id: "News")
    let api = SiteAPI.sharedInstance()
    
    @NSManaged var id: String
    @NSManaged var summaryHTML: String
    var summary: NSAttributedString?
    @NSManaged var textHTML: String?
    var text: NSAttributedString? {
        if let textHTML = self.textHTML {
            return self.api.parseHTMLString(textHTML)
        }
        return NSAttributedString(string: "")
    }
    @NSManaged var images: [Image]
    @NSManaged var previewImage:Image?
    @NSManaged var date: NSDate?
    @NSManaged var isFull:Bool
    var hasImages: Bool {
        return images.count > 0
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
    var dateStringShort: String {
        guard let date = date else {
            return ""
        }
        let locale = NSLocale(localeIdentifier: api.localeIdentifier)
        let formatter = NSDateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "dd MMM"
        return formatter.stringFromDate(date)
    }
    
    @NSManaged var category: Set<Category>
    override var types: [String] {
        return self.category.map { return $0.name }
    }
    override func filter(type: String) -> Bool {
        return self.category.contains { return $0.name == type }
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(id: String, summary: String, images: [String]? = nil, date: NSDate?, category: [String] = [], context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("News", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.id = id
        self.summaryHTML = summary
        self.textHTML = nil
        if let images = images {
            if images.count > 0 {
                let url = images[0]
                let image = Image(url: url, context: context)
                image.newsPreviewInverse = self
            }
        }
        self.date = date
        for tag in category {
            if let category = CoreDataStackManager.sharedInstance().fetchItem("Category", predicate: NSPredicate(format: "name == %@", tag)) as? Category {
                category.parent.insert(self)
            }
            let category = Category(name: tag, context: context)
            category.parent.insert(self)
        }
    }
    
    func fetchImage(index: Int, completion: (error: Bool, image: UIImage)->Void){
        if index >= self.images.count {
            return
        }
        
        let image = self.images[index]
        image.fetch(completion)
    }
    
    func fetchFull(completion:(error: NSError?)->Void){
        log.debug("fetchFull \(self.id)")
        api.getNewsItem(self.id) { (result, error) -> Void in
            guard let context = self.managedObjectContext else {
                completion(error: NSError(domain: "fetchFull error: no managed context found", code: 404, userInfo: nil))
                return
            }
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
            
            self.textHTML = result.text
            if let urls = result.imageUrls {
                for url in urls {
                    let image = Image(url: url, context: context)
                    image.newsInverse = self
                }
            }
            
            self.isFull = true
            
            self.log.debug("update news item: save context")
            CoreDataStackManager.sharedInstance().saveContext()
            completion(error: nil)
        }
    }
    
    func getSummary() -> NSAttributedString {
        if let res = self.summary {
            return res
        } else if let res = SiteAPI.sharedInstance().parseHTMLString(summaryHTML) {
            summary = res
            return res
        } else {
            return NSAttributedString(string: summaryHTML)
        }
    }
}
