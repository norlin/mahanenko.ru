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
    var image: UIImage?
    let imageUrl: String?
    var image3d: UIImage?
    let image3dUrl: String?
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
        self.summary = summary.attributedStringWith(font)
        self.seria = seria
        self.imageUrl = image
        self.image3dUrl = image3d
        self.date = date
        self.state = state
    }
    
    func fetchImage(need3d: Bool, completion: (image: UIImage)->Void){
        if need3d && image3d != nil {
            completion(image: image3d!)
            return
        }
        
        if !need3d && image != nil {
            completion(image: image!)
            return
        }
        
        guard let url:String = need3d ? image3dUrl : imageUrl else {
            return
        }
        let imageURL = NSURL(string: url)
        
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        dispatch_async(backgroundQueue) {
            if let imageData = NSData(contentsOfURL: imageURL!) {
                if let image = UIImage(data: imageData) {
                    if need3d {
                        self.image3d = image
                    } else {
                        self.image = image
                    }
                    dispatch_async(dispatch_get_main_queue()){
                        completion(image: image)
                    }
                }
            }
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