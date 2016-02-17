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
    var images: [Image] = []
    let previewImage:Image?
    let date: NSDate?
    var isFull:Bool = false
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
    
    var category: [Category] = []
    override var types: [String] { return self.category.map({return $0.name}) }
    override func filter(type: String) -> Bool {
        return self.category.contains({return $0.name == type})
    }
    
    init(id: String, summary: NSAttributedString, images: [String]? = nil, date: NSDate?, category: [String] = []) {
        self.id = id
        self.summary = summary
        self.text = nil
        if let images = images {
            if images.count > 0 {
                let url = images[0]
                self.previewImage = Image(url: url)
            } else {
                self.previewImage = nil
            }
        } else {
            self.previewImage = nil
        }
        self.date = date
        for name in category {
            self.category.append(Category(name: name))
        }
    }
    
    func fetchImage(index: Int, completion: (image: UIImage)->Void){
        if index >= self.images.count {
            return
        }
        
        let image = self.images[index]
        image.fetch(completion)
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
                for url in urls {
                    self.images.append(Image(url: url))
                }
            }
            
            self.isFull = true
            
            completion(error: nil)
        }

    }
}
