//
//  NewsCell.swift
//  mahanenko.ru
//
//  Created by norlin on 18/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class NewsCellView: TableCellView {
    let log = Log(id: "NewsCellView")
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var textToImage: NSLayoutConstraint!
    
    let NEWS_FONT = UIFont(name: "Helvetica Neue", size: 16)!
    
    func configure(item: News){
        log.notice("configure")
        if item.hasImages {
            self.imageView?.image = nil
            item.fetchImage(0){image in
                self.newsImage.image = image
            }
        }
        
        textToImage?.active = item.hasImages
        newsDate.text = "\(item.dateString)"
        newsText.attributedText = item.description.attributedStringWith(NEWS_FONT)
    }
    
}
