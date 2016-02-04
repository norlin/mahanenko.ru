//
//  NewsCell.swift
//  mahanenko.ru
//
//  Created by norlin on 18/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class NewsCellView: TableCellView {
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var textToImage: NSLayoutConstraint!
    
    func configure(item: News){
        if item.hasImages {
            item.fetchImage(0){image in
                self.newsImage.image = image
            }
        }
        
        textToImage?.active = item.hasImages
        newsDate.text = "\(item.dateString)"
        newsText.attributedText = item.description
    }
    
}
