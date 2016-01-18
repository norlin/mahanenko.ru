//
//  NewsCell.swift
//  mahanenko.ru
//
//  Created by norlin on 18/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class NewsCellView: UITableViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var detailsButton: UIButton!
    
    func configure(item: News, index: Int){
        newsImage.image = item.images[0]
        newsDate.text = "\(item.date) \(index)"
        newsText.text = item.text
        
        let sizeThatFits = newsText.sizeThatFits(CGSize(width: self.frame.width, height: 141))
        newsText.frame.size = sizeThatFits
//        print("\(newsText.sizeToFit()) \(sizeThatFits) \(newsText.frame.size)")
            
        newsText.preferredMaxLayoutWidth = newsText.frame.width
    }
}
