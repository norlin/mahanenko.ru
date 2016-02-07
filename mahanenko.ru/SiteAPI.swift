//
//  SiteAPI.swift
//  mahanenko.ru
//
//  Created by norlin on 03/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

enum Lang {
    case Russian
    case English
}

class SiteAPI: HTTP {
    let log = Log(id: "SiteAPI")
    struct Constants {
        static let BaseURL: String = "http://mahanenko.ru/%@/api"
        static let ApiKey = "12342352453"
        static let FacebookAppID = "365362206864879"
        static let FacebookScheme = "onthemap"
    }
    
    struct Methods {
        static let NewsList = "/news"
        static let NewsItem = "/article?args[0]=%@"
        static let BooksList = "/books"
        static let Book = "/book?args[0]=%@"
        static let BookText = "/booktext?args[0]=%@"
    }
    
    struct Keys {
        // Common
        static let Language: String = "language"
        static let Date: String = "created"
        static let Description: String = "summary"
        // News
        static let NewsId: String = "news_id"
        static let Category: String = "category"
        static var Image: String {
            switch SiteAPI.sharedInstance().lang {
            case .Russian: return "изображение"
            case .English: return "image"
            }
        }
        static let Images: String = "images"
        static var Text: String {
            switch SiteAPI.sharedInstance().lang {
            case .Russian: return "текст"
            case .English: return "text"
            }
        }
        //Books
        static let BookId: String = "book_id"
        static let BookTitle: String = "book_title"
        static let Funfic: String = "is_funfic"
        static let ImageFront: String = "image_front"
        static let Image3d: String = "image_3d"
        static let Seria: String = "book_seria"
        static var State: String {
            switch SiteAPI.sharedInstance().lang {
            case .Russian: return "состояние"
            case .English: return "state"
            }
        }
    }
    
    var lang:Lang {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject([langString, oppositeLangString], forKey: "AppleLanguages")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    var langString: String {
        switch lang {
        case .Russian: return "ru"
        case .English: return "en"
        }
    }
    var oppositeLangString: String {
        switch lang {
        case .Russian: return "en"
        case .English: return "ru"
        }
    }
    var langName: String {
        switch lang {
        case .Russian: return "Русский"
        case .English: return "English"
        }
    }
    var oppositeLangName: String {
        switch lang {
        case .Russian: return "English"
        case .English: return "Русский"
        }
    }
    var localeIdentifier: String {
        switch lang {
        case .Russian: return "ru_RU"
        case .English: return "en_EN"
        }
    }
    
    override init() {
        log.notice("init")
        let systemLang = NSUserDefaults.standardUserDefaults().valueForKey("AppleLanguages")
        if let langs = systemLang {
            let preferredLang = langs[0] as! String
            switch preferredLang {
            case "en":
                self.lang = .English
            default:
                self.lang = .Russian
            }
        } else {
            self.lang = .Russian
        }
        
        super.init()
    }
    
    // News
    func getNewsList(completion: (result: [News]?, error: NSError?) -> Void) {
        log.notice("getNewsList")
        let baseUrl = getBaseUrl()
        let methodUrl = Methods.NewsList
        let url = "\(baseUrl)\(methodUrl)"
        
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        dispatch_async(backgroundQueue) {
            self.get(url){result, error in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue()){
                        completion(result: nil, error: error)
                    }
                    return
                }
                guard let result = result else {
                    let error = HTTP.Error("SiteAPI.getNewsList", code: 404, msg: "Can't fetch news list")
                    dispatch_async(dispatch_get_main_queue()){
                        completion(result: nil, error: error)
                    }
                    return
                }
                
                var news = [News]()
                if let list = result as? [[String: AnyObject]] {
                    for (item) in list {
                        if let newsItem = self.parseNewsItem(item) {
                            news.append(newsItem)
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue()){
                        completion(result: news, error: nil)
                    }
                }
            }
        }
    }
    
    func getNewsItem(id: String, completion: (result: NewsFull?, error: NSError?) -> Void) {
        log.notice("getNewsList")
        let baseUrl = getBaseUrl()
        let methodUrl = String(format: Methods.NewsItem, id)
        let url = "\(baseUrl)\(methodUrl)"
        
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        dispatch_async(backgroundQueue) {
            self.get(url){result, error in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue()){
                        completion(result: nil, error: error)
                    }
                    return
                }
                guard let result = result else {
                    let error = HTTP.Error("SiteAPI.getNewsList", code: 404, msg: "Can't fetch news list")
                    dispatch_async(dispatch_get_main_queue()){
                        completion(result: nil, error: error)
                    }
                    return
                }
                
                if let items = result as? [[String: AnyObject]] {
                    let item = items[0]
                    let newsUpdate = self.parseNewsItemFull(item)
                    
                    dispatch_async(dispatch_get_main_queue()){
                        completion(result: newsUpdate, error: nil)
                    }
                }
            }
        }
    }
    
    func parseNewsItem(item: [String: AnyObject]) -> News? {
        guard let id = item[Keys.NewsId] as? String else {
            return nil
        }
        // parse date
        guard let dateString = item[Keys.Date] as? String else {
            return nil
        }
        let locale = NSLocale(localeIdentifier: self.localeIdentifier)
        let formatter = NSDateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "EEEE, MMMM d, yyyy - HH:mm"
        formatter.timeZone = NSTimeZone(name: "Europe/Moscow")
        let date = formatter.dateFromString(dateString)
        
        // parse description
        guard let summaryHTML = item[Keys.Description] as? String else {
            return nil
        }
        let data = summaryHTML.dataUsingEncoding(NSUTF8StringEncoding)
        let opts:[String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding,
            NSKernAttributeName: NSNull()
        ]
        guard let summary = try? NSAttributedString.init(data: data!, options: opts, documentAttributes: nil) else {
            return nil
        }
        
        let images = item[Keys.Image] as? [String]
        
        let category = item[Keys.Category] as? [String]
        return News(id: id, summary: summary, images: images, date: date, category: category==nil ? [] : category!)
    }
    
    func parseNewsItemFull(item: [String: AnyObject]) -> NewsFull? {
        // parse text html
        guard let textHTML = item[Keys.Text] as? String else {
            return nil
        }
        
        let textData = textHTML.dataUsingEncoding(NSUTF8StringEncoding)
        let opts:[String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding,
            NSKernAttributeName: NSNull()
        ]
        guard let text = try? NSAttributedString.init(data: textData!, options: opts, documentAttributes: nil) else {
            return nil
        }
        
        let images = item[Keys.Images] as? [String]
        return NewsFull(text: text, imageUrls: images)
    }
    
    // Books
    func getBooksList(completion: (result: [Book]?, error: NSError?) -> Void) {
        log.notice("getBooksList")
        let baseUrl = getBaseUrl()
        let methodUrl = Methods.BooksList
        let url = "\(baseUrl)\(methodUrl)"
        
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        dispatch_async(backgroundQueue) {
            self.get(url){result, error in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue()){
                        completion(result: nil, error: error)
                    }
                    return
                }
                guard let result = result else {
                    let error = HTTP.Error("SiteAPI.getBooksList", code: 404, msg: "Can't fetch books list")
                    dispatch_async(dispatch_get_main_queue()){
                        completion(result: nil, error: error)
                    }
                    return
                }
                
                var books = [Book]()
                if let list = result as? [[String: AnyObject]] {
                    for (item) in list {
                        if let bookItem = self.parseBookItem(item) {
                            books.append(bookItem)
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue()){
                        completion(result: books, error: nil)
                    }
                }
            }
        }
    }
    
    func parseBookItem(item: [String: AnyObject]) -> Book? {
        guard let id = item[Keys.BookId] as? String else {
            return nil
        }
        guard let title = item[Keys.BookTitle] as? String else {
            return nil
        }
        // parse date
        guard let dateString = item[Keys.Date] as? String else {
            return nil
        }
        let locale = NSLocale(localeIdentifier: self.localeIdentifier)
        let formatter = NSDateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "EEEE, MMMM d, yyyy - HH:mm"
        formatter.timeZone = NSTimeZone(name: "Europe/Moscow")
        let date = formatter.dateFromString(dateString)
        
        // parse description
        guard let descriptionHTML = item[Keys.Description] as? String else {
            return nil
        }
        let data = descriptionHTML.dataUsingEncoding(NSUTF8StringEncoding)
        let opts:[String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding,
            NSKernAttributeName: NSNull()
        ]
        guard let description = try? NSAttributedString.init(data: data!, options: opts, documentAttributes: nil) else {
            return nil
        }
        
        let image = item[Keys.ImageFront] as? String
        let image3d = item[Keys.Image3d] as? String
        let seria = item[Keys.Seria] as? String
        let state = item[Keys.State] as? String
        
        return Book(id: id, title: title, summary: description, seria: seria, image: image, image3d: image3d, date: date, state: state)
    }

    // Common
    func getBaseUrl() -> String {
        return String(format: Constants.BaseURL, arguments: [langString])
    }
    
    func switchLang(){
        log.notice("switchLang")
        if lang == .Russian {
            lang = .English
        } else {
            lang = .Russian
        }
    }
    
    override class func sharedInstance() -> SiteAPI {
        struct Singleton {
            static var sharedInstance = SiteAPI()
        }
        
        return Singleton.sharedInstance
    }
    
}