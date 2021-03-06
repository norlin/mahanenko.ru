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
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    func configure(item: Book){
        log.debug("configure")
        
        self.bringSubviewToFront(loader)
        
        // TODO: create default fonts for the app
        title.font = Constants.TITLE3_FONT
        
        title.text = item.title
        title.sizeToFit()
        
        self.bookImage.hidden = true
        
        if let image = item.image3d {
            loader.startAnimating()
            image.fetch(){(error, image) in
                if (error){
                    self.bookImage.contentMode = UIViewContentMode.Center
                } else {
                    self.bookImage.contentMode = UIViewContentMode.ScaleAspectFit
                }
                self.bookImage.image = image
                self.loader.stopAnimating()
                self.bookImage.hidden = false
            }
        }
    }
    
}