//
//  Books.swift
//  mahanenko.ru
//
//  Created by norlin on 07/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class Book: FilterableItem {
    let log = Log(id: "Book")
    let api = SiteAPI.sharedInstance()
    
    let id: String
    var textId: String?
    let title: String
    let summary: NSAttributedString
    var image: UIImage?
    let imageUrl: String?
    var image3d: UIImage?
    let image3dUrl: String?
    let date: NSDate?
    let state: String?
    let seria: String?
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

}