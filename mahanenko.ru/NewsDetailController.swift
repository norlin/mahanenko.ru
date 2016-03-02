//
//  NewsDetailController.swift
//  mahanenko.ru
//
//  Created by norlin on 18/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit
import CoreData

class NewsDetailController: UIViewController {
    let log = Log(id: "NewsDetailController")
    
    @IBOutlet weak var newsText: UITextView!
    @IBOutlet weak var imagesScroll: ImageScroll!
    @IBOutlet weak var textToImage: NSLayoutConstraint!
    @IBOutlet weak var textHeight: NSLayoutConstraint?
    @IBOutlet weak var loader: Loader!
    var reloadButton: UIBarButtonItem!
    
    let imagesAspect:CGFloat = 184 / 375
    
    var newsId: NSManagedObjectID? {
        didSet {
            if let id = newsId {
                self.news = self.sharedContext.objectWithID(id) as? News
            }
        }
    }
    var news: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesScroll.backgroundColor = UIColor.blackColor()
        newsText.textContainerInset = view.layoutMargins
        view.bringSubviewToFront(loader)
        
        reloadButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "reloadDetails:")
        
        imagesScroll.scrollsToTop = false
        let tap = UITapGestureRecognizer(target: self, action: "showImages")
        imagesScroll.addGestureRecognizer(tap)
        
        self.configure()
    }
    
    func configure(){
        log.notice("configure")
        if let news = self.news {
            self.navigationItem.title = news.dateString
            if !news.isFull {
                newsText.hidden = true
                loader.center = newsText.center
                loader.startAnimating()
                self.log.debug("configure: fetch full item")
                news.fetchFull({ (error) -> Void in
                    if error == nil {
                        self.navigationItem.rightBarButtonItem = nil
                    } else {
                        self.log.error("fetchFull error: \(error)")
                        self.navigationItem.rightBarButtonItem = self.reloadButton
                    }
                    self.log.debug("configure: fetch done")
                    
                    dispatch_async(dispatch_get_main_queue()){
                        self.updateNewsItem(error)
                        self.newsText.hidden = false
                        self.loader.stopAnimating()
                    }
                })
            } else {
                self.updateNewsItem(nil)
            }
        } else {
            log.warning("No news item found!")
        }
    }
    
    var imageViews = [UIImageView]()
    
    func updateNewsItem(error: NSError?){
        log.notice("updateNewsItem")
        if error != nil {
            AlertViewController.showAlert(self, message: NSLocalizedString("Something goes wrong while fetching news text\n\nPlease try to reload", comment: "News details fetching error"))
            return
        }
        guard let news = self.news else {
            return
        }
        
        newsText.text = news.text?.string
        
        if (news.hasImages) {
            imagesScroll.images = news.images
        } else if let preview = news.previewImage {
            imagesScroll.images = [preview]
        } else {
            imagesScroll.images = []
        }

        imagesScroll.hidden = imagesScroll.images.count == 0
        textToImage.active = imagesScroll.images.count > 0
    }
    
    func reloadDetails(sender: AnyObject) {
        configure()
    }
    
    func showImages(){
        if imagesScroll.images.count == 0 {
            return
        }
        
        ImageViewController.showViewer(self, images: imagesScroll.images)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imagesScroll.frame.size.width = self.view.frame.width
        
        newsText.sizeToFit()
        if let height = textHeight {
            height.constant = newsText.contentSize.height
        }
        newsText.layoutIfNeeded()
        imagesScroll.updateImages()
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
}
