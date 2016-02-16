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
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var titleImageGap: NSLayoutConstraint!
    @IBOutlet weak var summary: UITextView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var seriaLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var seriaLabelMain: NSLayoutConstraint!
    @IBOutlet weak var summaryMain: NSLayoutConstraint!
    
    var imageViewConstraints:[NSLayoutConstraint]!
    var textModeState = false
    
    let imagesAspect:CGFloat = 392 / 335
    let bgPattern = UIImage(named: "Background")!
    
    
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bringSubviewToFront(mainLoader)
        topView.bringSubviewToFront(imageLoader)
        bookImage.hidden = true
        bookTitle.hidden = true
        bookSeria.hidden = true
        seriaLabel.hidden = true
        
        summary.textContainerInset = UIEdgeInsets(top: 0, left: view.layoutMargins.left, bottom: 0, right: view.layoutMargins.right)
        
        view.backgroundColor = UIColor(patternImage: self.bgPattern)
        
        let textModeTap = UITapGestureRecognizer(target: self, action: "switchMode")
        summary.addGestureRecognizer(textModeTap)
        let imageModeTap = UITapGestureRecognizer(target: self, action: "switchMode")
        bookImage.addGestureRecognizer(imageModeTap)
        imageViewConstraints = [seriaLabelLeading, seriaLabelMain, summaryMain]
        
        self.configure()
    }
    
    func getImageHeight(titleHeight: CGFloat) -> CGFloat {
        let viewWidth = view.frame.width
        let margins = view.layoutMargins.left + view.layoutMargins.right
        let contentWidth = viewWidth - margins
        
        return titleHeight + titleImageGap.constant + (contentWidth * imagesAspect)
    }
    
    func getTitleHeight() -> CGFloat {
        let size = bookTitle.sizeThatFits(CGSize(width: bookTitle.frame.width, height: 200))
        return size.height
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
        let height = getTitleHeight()
        titleHeight.constant = height
        summary.sizeToFit()
        setImageMode(false)
        
        bookSeria.text = book.seria
        bookSeria.hidden = false
        seriaLabel.hidden = false
        
        summary.attributedText = book.summary.attributedStringWith(Constants.TEXT_FONT)
        
        self.imageLoader.startAnimating()
        book.fetchImage(true) {image in
            self.bookImage.image = image
            self.imageLoader.stopAnimating()
            self.bookImage.hidden = false
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        setTextMode(animated)
    }
    
    func switchMode(){
        if textModeState {
            setImageMode()
        } else {
            setTextMode()
        }
    }
    
    func setTextMode(animated: Bool = true){
        log.debug("setTextMode")
        let titleHeight = getTitleHeight()
        imageHeight.constant = 100 + titleHeight
        NSLayoutConstraint.deactivateConstraints(imageViewConstraints)
        if animated {
            UIView.animateWithDuration(0.1, animations: {
                self.seriaLabel.alpha = 0
                self.bookSeria.alpha = 0
            })
            UIView.animateWithDuration(0.5, animations: {
                self.view.layoutIfNeeded()
            }){ success in
                UIView.animateWithDuration(0.1, animations: {
                    self.seriaLabel.alpha = 1
                    self.bookSeria.alpha = 1
                    self.textModeState = true
                })
            }
        } else {
            self.view.layoutIfNeeded()
        }
    }
    
    func setImageMode(animated: Bool = true){
        log.debug("setImageMode")
        let height = getImageHeight(getTitleHeight())
        self.imageHeight.constant = height
        NSLayoutConstraint.activateConstraints(imageViewConstraints)
        if animated {
            UIView.animateWithDuration(0.1, animations: {
                self.seriaLabel.alpha = 0
                self.bookSeria.alpha = 0
            })
            UIView.animateWithDuration(0.5, animations: {
                self.view.layoutIfNeeded()
            }){ success in
                UIView.animateWithDuration(0.1, animations: {
                    self.seriaLabel.alpha = 1
                    self.bookSeria.alpha = 1
                    self.textModeState = false
                })
            }
        } else {
            self.view.layoutIfNeeded()
        }
    }
}