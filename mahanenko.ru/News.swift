//
//  News.swift
//  mahanenko.ru
//
//  Created by norlin on 18/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class News {
    let api = SiteAPI.sharedInstance()
    let description: NSAttributedString
    let text: NSAttributedString
    var images: [UIImage]
    let imageUrls: [String]?
    let date: NSDate?
    let category: [String]
    var hasImages: Bool {
        return imageUrls != nil
    }
    var dateString: String {
        guard let date = date else {
            return ""
        }
        let locale = NSLocale(localeIdentifier: "ru_RU")
        let formatter = NSDateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "dd MMMM yyyy, HH:mm"
        return formatter.stringFromDate(date)
    }
    
    let font = UIFont(name: "Helvetica Neue", size: 16)!
    
    init(text: NSAttributedString, images: [String]?, date: NSDate?, category: [String]) {
        self.description = text.attributedStringWith(font)
        self.text = self.description
        self.imageUrls = images
        self.images = []
        self.date = date
        self.category = category
    }
    
    init(description: NSAttributedString, text: NSAttributedString, images: [String]? = nil, date: NSDate?, category: [String] = []) {
        self.description = description.attributedStringWith(font)
        self.text = text.attributedStringWith(font)
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
}
    
enum NewsFilterType {
    case All
    case Shaman
    case Galaktiona
}

class NewsFetcher {
    var api = SiteAPI.sharedInstance()

    func getNews(completion: (result: [News]?, error: NSError?) -> Void) {
        api.getNewsList(completion)
    }

    class func sharedInstance() -> NewsFetcher {
        struct Singleton {
            static var sharedInstance = NewsFetcher()
        }
        
        return Singleton.sharedInstance
    }
}