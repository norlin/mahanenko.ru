//
//  SiteAPI.swift
//  mahanenko.ru
//
//  Created by norlin on 03/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class SiteAPI: HTTP {
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
    }
    
    struct Keys {
        static let NewsId: String = "news_id"
        static let Category: String = "category"
        static let Description: String = "summary"
        static let Language: String = "language"
        static let Date: String = "created"
        static var Image: String {
            switch SiteAPI.sharedInstance().lang {
            case .Russian: return "изображение"
            case .English: return "image"
            }
        }
    }
    
    enum Lang {
        case Russian
        case English
    }
    
    var lang:Lang = .Russian
    var langString: String {
        switch lang {
        case .Russian: return "ru"
        case .English: return "en"
        }
    }
    
    func getNewsList(completion: (result: [News]?, error: NSError?) -> Void) {
        let baseUrl = getBaseUrl()
        let methodUrl = Methods.NewsList
        let url = "\(baseUrl)\(methodUrl)"
        
        self.get(url){result, error in
            if error != nil {
                completion(result: nil, error: error)
                return
            }
            guard let result = result else {
                let error = HTTP.Error("SiteAPI.getNewsList", code: 404, msg: "Can't fetch news list")
                return completion(result: nil, error: error)
            }
            
            var news = [News]()
            if let list = result as? [[String: AnyObject]] {
                for (item) in list {
                    guard let descriptionHTML = item[Keys.Description] as? String else {
                        continue
                    }
                    let data = descriptionHTML.dataUsingEncoding(NSUTF8StringEncoding)
                    let opts:[String: AnyObject] = [
                        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                        NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding,
                        NSKernAttributeName: NSNull()
                    ]
                    guard let description = try? NSAttributedString.init(data: data!, options: opts, documentAttributes: nil) else {
                        continue
                    }
                    guard let date = item[Keys.Date] as? String else {
                        continue
                    }
                    let images = item[Keys.Image] as? [String]
                    let newsItem = News(text: description, images: images, date: date, type: .Shaman)
                    news.append(newsItem)
                }
                
                completion(result: news, error: nil)
            }
        }
    }
    
    func getBaseUrl() -> String {
        return String(format: Constants.BaseURL, arguments: [langString])
    }
    
    override class func sharedInstance() -> SiteAPI {
        struct Singleton {
            static var sharedInstance = SiteAPI()
        }
        
        return Singleton.sharedInstance
    }
    
}