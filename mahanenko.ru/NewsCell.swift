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
    
    func configure(item: News, index: Int){
        if let images = item.images {
            newsImage.image = images[0]
        }
        
        if textToImage != nil {
            textToImage.active = item.images != nil
        }
        newsDate.text = "\(item.date) \(index)"
        newsText.text = item.description
        
        let sizeThatFits = newsText.sizeThatFits(CGSize(width: self.frame.width, height: 141))
        newsText.frame.size = sizeThatFits
        newsText.preferredMaxLayoutWidth = newsText.frame.width
    }
    
}
