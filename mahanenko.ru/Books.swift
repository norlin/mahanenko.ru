//
//  Books.swift
//  mahanenko.ru
//
//  Created by norlin on 07/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

struct BookFull {
    let summary: NSAttributedString!
    let ebookFile: String?
    let freeBookTextId: String?
}

class Book: FilterableItem {
    let log = Log(id: "Book")
    let api = SiteAPI.sharedInstance()
    
    let id: String
    var textId: String?
    let title: String
    var summary: NSAttributedString
    let image: Image?
    let image3d: Image?
    let date: NSDate?
    let state: String?
    let seria: String?
    var ebookFile: String?
    var freeBookTextId: String?
    var isFull: Bool = false
    
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
    
    let font = UIFont(name: "Helvetica Neue", size: 16)!
    
    init(id: String, textId: String? = nil, title: String, summary: NSAttributedString, seria: String?, image: String?, image3d: String?, date: NSDate?, state: String?) {
        self.id = id
        self.textId = textId
        self.title = title
        self.seria = seria
        self.date = date
        self.state = state
        self.summary = summary.attributedStringWith(font)
        
        if let image = image {
            self.image = Image(url: image)
        } else {
            self.image = nil
        }
        
        if let image = image3d {
            self.image3d = Image(url: image)
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
            
            self.summary = result.summary
            self.freeBookTextId = result.freeBookTextId
            self.ebookFile = result.ebookFile
            
            self.isFull = true
            
            completion(error: nil)
        }

    }

}