//
//  News.swift
//  mahanenko.ru
//
//  Created by norlin on 18/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

struct NewsFull {
    let text: NSAttributedString
    let imageUrls: [String]?
}

class News: FilterableItem {
    let log = Log(id: "News")
    let api = SiteAPI.sharedInstance()
    
    let id: String
    let summary: NSAttributedString
    var text: NSAttributedString?
    var images: [UIImage]
    var imageUrls: [String]?
    let date: NSDate?
    var isFull:Bool = false
    var hasImages: Bool {
        return imageUrls != nil
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
    
    let category: [String]
    override var types: [String] { return self.category }
    override func filter(type: String) -> Bool {
        return self.category.contains(type)
    }
    
    init(id: String, summary: NSAttributedString, images: [String]? = nil, date: NSDate?, category: [String] = []) {
        self.id = id
        self.summary = summary
        self.text = nil
        self.imageUrls = images
        self.images = []
        self.date = date
        self.category = category
    }
    
    func fetchImage(index: Int, completion: (image: UIImage)->Void){
        guard let urls = imageUrls else {
            return
        }
        
        if index >= urls.count {
            return
        }
        
        if index < images.count {
            completion(image: images[index])
            return
        }
        let url = urls[index]
        let imageURL = NSURL(string: url)
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        dispatch_async(backgroundQueue) {
            if let imageData = NSData(contentsOfURL: imageURL!) {
                if let image = UIImage(data: imageData) {
                    self.images.append(image)
                    dispatch_async(dispatch_get_main_queue()){
                        completion(image: image)
                    }
                }
            }
        }
    }
    
    func fetchFull(completion:(error: NSError?)->Void){
        log.debug("fetchFull \(self.id)")
        api.getNewsItem(self.id) { (result, error) -> Void in
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
            
            self.text = result.text
            if let urls = result.imageUrls {
                self.imageUrls = urls
            }
            
            self.isFull = true
            
            completion(error: nil)
        }

    }
}
