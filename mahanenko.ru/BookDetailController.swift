//
//  BookDetailController.swift
//  mahanenko.ru
//
//  Created by norlin on 15/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit
import CoreData

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
    var reloadButton: UIBarButtonItem!
    
    var imageViewConstraints:[NSLayoutConstraint]!
    var textModeState = false
    
    let imagesAspect:CGFloat = 392 / 335
    let bgPattern = UIImage(named: "Background")!
    
    var bookId: NSManagedObjectID? {
        didSet {
            if let id = bookId {
                self.book = self.sharedContext.objectWithID(id) as? Book
            }
        }
    }
    var book: Book?
    var bookImageReady = false
    var appeared = false
    var userAction = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bringSubviewToFront(mainLoader)
        topView.bringSubviewToFront(imageLoader)
        bookImage.alpha = 0
        bookTitle.alpha = 0
        bookSeria.alpha = 0
        seriaLabel.alpha = 0
        summary.alpha = 0
        
        summary.textContainerInset = UIEdgeInsets(top: 0, left: view.layoutMargins.left, bottom: 0, right: view.layoutMargins.right)
        
        view.backgroundColor = UIColor(patternImage: self.bgPattern)
        
        let textModeTap = UITapGestureRecognizer(target: self, action: "setTextMode")
        summary.addGestureRecognizer(textModeTap)
        let imageModeTap = UITapGestureRecognizer(target: self, action: "showImage")
        bookImage.addGestureRecognizer(imageModeTap)
        imageViewConstraints = [seriaLabelLeading, seriaLabelMain, summaryMain]
        
        reloadButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "reloadDetails:")
        
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
                    if error == nil {
                        self.navigationItem.rightBarButtonItem = nil
                    } else {
                        self.log.error("fetchFull error: \(error)")
                        self.navigationItem.rightBarButtonItem = self.reloadButton
                    }
                    
                    dispatch_async(dispatch_get_main_queue()){
                        self.log.debug("book full ready")
                        self.updateBookItem(error)
                        self.mainLoader.stopAnimating()
                    }
                })
            } else {
                self.updateBookItem(nil)
            }
        } else {
            log.warning("No news item found!")
        }
    }
    
    func reloadDetails(sender: AnyObject) {
        configure()
    }
    
    func updateBookItem(error: NSError?){
        if error != nil {
            AlertViewController.showAlert(self, message: NSLocalizedString("Something goes wrong while fetching book info\n\nPlease try to reload", comment: "Book details fetching error"))
            return
        }
        
        guard let book = self.book else {
            // TODO: handle error
            return
        }
        log.notice("updateBookItem")
        
        bookTitle.text = book.title
        bookTitle.sizeToFit()
        let height = getTitleHeight()
        titleHeight.constant = height
        
        bookSeria.text = book.seria
        bookSeria.sizeToFit()
        summary.attributedText = book.summary.attributedStringWith(Constants.TEXT_FONT)
        summary.sizeToFit()
        
        setImageMode(false)
        
        UIView.animateWithDuration(0.5, animations: {
            self.bookImage.alpha = 1
            self.bookTitle.alpha = 1
            self.summary.alpha = 1
        })
        
        if let image = book.image3d {
            self.imageLoader.startAnimating()
            image.fetch() {(error, image) in
                if (error){
                    self.bookImage.contentMode = UIViewContentMode.Center
                }
                self.bookImage.image = image
                self.imageLoader.stopAnimating()
                self.bookImage.hidden = false
                self.bookImageReady = true
                self.updateView()
            }
        } else {
            self.bookImageReady = true
            self.updateView()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        log.debug("viewDidAppear")
        appeared = true
        updateView()
    }
    
    func updateView(){
        if (bookImageReady && appeared && !userAction){
            setTextMode(true)
        }
    }
    
    func switchMode(){
        userAction = true
        if textModeState {
            setImageMode()
        } else {
            setTextMode(true)
        }
    }
    
    func setTextMode(){
        userAction = true
        setTextMode(true)
    }
    
    func setTextMode(animated: Bool = true){
        log.debug("setTextMode")
        if (textModeState){
            return
        }
        let titleHeight = getTitleHeight()
        imageHeight.constant = 100 + titleHeight
        NSLayoutConstraint.deactivateConstraints(imageViewConstraints)
        self.textModeState = true
        if animated {
            UIView.animateWithDuration(0.1, animations: {
                self.seriaLabel.alpha = 0
                self.bookSeria.alpha = 0
            })
            UIView.animateWithDuration(0.5, animations: {
                self.summary.alpha = 1
                self.view.layoutIfNeeded()
            }){ success in
                UIView.animateWithDuration(0.1, animations: {
                    self.seriaLabel.alpha = 1
                    self.bookSeria.alpha = 1
                })
            }
        } else {
            self.view.layoutIfNeeded()
            self.summary.alpha = 1
        }
    }
    
    func setImageMode(animated: Bool = true){
        log.debug("setImageMode")
        if (!textModeState){
            return
        }
        let height = getImageHeight(getTitleHeight())
        self.imageHeight.constant = height
        NSLayoutConstraint.activateConstraints(imageViewConstraints)
        self.textModeState = false
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
                    if (self.summary.frame.height < 21){
                        self.summary.alpha = 0
                    }
                })
            }
        } else {
            self.view.layoutIfNeeded()
            if (self.summary.frame.height < 21){
                self.summary.alpha = 0
            }
        }
    }
    
    func showImage(){
        guard let book = self.book else {
            return
        }
        if let image = book.image3d {
            ImagePagesController.showViewer(self, images: [image])
        }
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
}