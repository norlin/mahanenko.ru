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
    
    func configure(item: News){
        newsImage.image = item.images[0]
        newsText.text = item.text
        newsText.preferredMaxLayoutWidth = newsText.frame.width
        newsDate.text = item.date
    }
}
