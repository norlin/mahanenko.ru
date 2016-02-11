//
//  BookCell.swift
//  mahanenko.ru
//
//  Created by norlin on 07/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class BookCellView: CollectionCellView {
    let log = Log(id: "BookCellView")

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    var loader: Loader!
    
    func configure(item: Book){
        log.notice("configure")
        
        if loader == nil {
            loader = Loader(activityIndicatorStyle: .White)
            loader.frame = bookImage.frame
            self.addSubview(loader)
            self.bringSubviewToFront(loader)
            
            title.font = Constants.TEXT_FONT
        }
        
        title.text = item.title
        
        if let image = item.image3d {
            self.bookImage.image = image
        } else {
            loader.startAnimating()
            self.bookImage?.hidden = true
            
            item.fetchImage(true){image in
                self.bookImage.image = image
                self.bookImage.hidden = false
                self.loader.stopAnimating()
            }
        }
    }
    
}

