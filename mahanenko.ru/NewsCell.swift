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
    @IBOutlet weak var loader: Loader!
    
    func configure(item: News){
        log.debug("configure")
        
        self.bringSubviewToFront(loader)
        
        self.newsImage.hidden = true
        if item.hasImages {
            loader.startAnimating()
            item.fetchImage(0){image in
                self.newsImage.image = image
                self.loader.stopAnimating()
                self.newsImage.hidden = false
            }
        }
        
        textToImage?.active = item.hasImages
        newsDate.text = "\(item.dateString)"
        newsText.attributedText = item.summary.attributedStringWith(Constants.TEXT_FONT)
    }
    
}
