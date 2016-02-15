//
//  BookDetailController.swift
//  mahanenko.ru
//
//  Created by norlin on 15/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class BookDetailController: UIViewController {
    let log = Log(id: "BookDetailController")
    
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var mainLoader: UIActivityIndicatorView!
    @IBOutlet weak var imageLoader: UIActivityIndicatorView!
    @IBOutlet weak var seriaLabel: UILabel!
    @IBOutlet weak var bookSeria: UILabel!
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    
    let imagesAspect:CGFloat = 184 / 375
    let bgPattern = UIImage(named: "Background")!
    
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bringSubviewToFront(mainLoader)
        bookImage.hidden = true
        bookTitle.hidden = true
        bookSeria.hidden = true
        seriaLabel.hidden = true
        
        view.backgroundColor = UIColor(patternImage: self.bgPattern)
        self.configure()
    }
    
    func configure(){
        log.notice("configure")
        
        if let book = self.book {
            if !book.isFull {
                mainLoader.startAnimating()
                log.debug("book.fetchFull")
                book.fetchFull({ (error) -> Void in
                    if error != nil {
                        self.log.error("fetchFull error: \(error)")
                    }
                    
                    dispatch_async(dispatch_get_main_queue()){
                        self.updateBookItem()
                        self.mainLoader.stopAnimating()
                    }
                })
            } else {
                self.updateBookItem()
            }
        } else {
            log.warning("No news item found!")
        }
    }
    
    func updateBookItem(){
        guard let book = self.book else {
            return
        }
        log.notice("updateBookItem")
        
        bookTitle.text = book.title
        bookTitle.hidden = false
        let height = bookTitle.sizeThatFits(CGSize(width: bookTitle.frame.width, height: 200)).height
        titleHeight.constant = height
        bookSeria.text = book.seria
        bookSeria.hidden = false
        seriaLabel.hidden = false
        self.imageLoader.startAnimating()
        book.fetchImage(true) {image in
            self.bookImage.image = image
            self.imageLoader.stopAnimating()
            self.bookImage.hidden = false
        }
    }
}