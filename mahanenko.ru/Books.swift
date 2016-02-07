//
//  Books.swift
//  mahanenko.ru
//
//  Created by norlin on 07/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class Book {
    let log = Log(id: "Book")
    let api = SiteAPI.sharedInstance()
    
    let id: String
    let title: String
    let summary: NSAttributedString
    var image: UIImage?
    let image_url: String
    var image_3d: UIImage?
    let image_3d_url: String
    let date: NSDate?
    let seria: [String]
    let state: String
    let is_funfic: Bool

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
    
    init(id: String, title: String, summary: NSAttributedString, seria: [String], image: String, image_3d: String, date: NSDate, state: String, is_funfic: Bool) {
        self.id = id
        self.title = title
        self.summary = summary.attributedStringWith(font)
        self.seria = seria
        self.image_url = image
        self.image_3d_url = image_3d
        self.date = date
        self.state = state
        self.is_funfic = is_funfic
    }
}