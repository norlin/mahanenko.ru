//
//  BookCell.swift
//  mahanenko.ru
//
//  Created by norlin on 07/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class BookCellView: TableCellView {
    let log = Log(id: "BookCellView")

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var textToImage: NSLayoutConstraint!
    
    func configure(item: Book){
        log.notice("configure")
        
        title.text = item.title
        summary.attributedText = item.summary.attributedStringWith(Constants.TEXT_FONT)
        
        /*if item.hasImages {
            self.imageView?.image = nil
            item.fetchImage(0){image in
                self.newsImage.image = image
            }
        }
        
        textToImage?.active = item.hasImages
        newsDate.text = "\(item.dateString)"
        newsText.attributedText = item.description.attributedStringWith(NEWS_FONT)*/
    }
    
}

