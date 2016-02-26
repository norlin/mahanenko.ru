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
    
    @IBOutlet weak var newsDate: NewsDateLabel!
    @IBOutlet weak var newsText: UITextView!
    @IBOutlet weak var imagesScroll: UIScrollView!
    @IBOutlet weak var textToImage: NSLayoutConstraint!
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
        
        self.configure()
    }
    
    func configure(){
        log.notice("configure")
        if let news = self.news {
            newsDate.text = news.dateStringShort
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
        newsText.layoutIfNeeded()
        
        let newsImages:[Image]
        
        if (news.hasImages) {
            newsImages = news.images
        } else if let preview = news.previewImage {
            newsImages = [preview]
        } else {
            newsImages = []
        }
        let compact = self.traitCollection.verticalSizeClass == .Compact
        
        if newsImages.count > 0 {
            log.debug("updateNewsItem: fetch images")

            let width = imagesScroll.frame.size.width
            let height = width * imagesAspect
            let imageFrame = CGSize(width: width, height: height)
            imagesScroll.contentSize = CGSize(width: CGFloat(newsImages.count) * width, height: height)
            let imgCenterY = imagesScroll.center.y
            
            if (newsImages.count != imageViews.count) {
                for imageView in imageViews {
                    imageView.removeFromSuperview()
                }
                imageViews.removeAll()
            }

            for (index, image) in newsImages.enumerate() {
                let imageView:UIImageView
                let loader: Loader
                if imageViews.count > index {
                    imageView = imageViews[index]
                } else {
                    imageView = UIImageView()
                    imageView.contentMode = .ScaleAspectFill
                    imageViews.append(imageView)
                    imagesScroll.addSubview(imageView)
                }
                if let existingLoader = imageView.subviews.filter({ $0.isKindOfClass(Loader) }).first as? Loader {
                    loader = existingLoader
                } else {
                    loader = Loader(activityIndicatorStyle: .Gray)
                    imagesScroll.addSubview(loader)
                }
                
                imageView.frame = CGRect(origin: CGPoint(x: CGFloat(index) * width, y: 0), size: imageFrame)
                if compact {
                    imageView.center.y = imgCenterY
                }
                loader.center = imageView.center
                
                if (imageView.image != nil && imageView.image == image.image && !image.error) {
                    continue
                }
                
                loader.startAnimating()
                image.fetch(){ (error, image) in
                    if (error){
                        imageView.contentMode = UIViewContentMode.Center
                    }
                    dispatch_async(dispatch_get_main_queue()){
                        imageView.image = image
                        loader.stopAnimating()
                    }
                }
            }
        
        } else {
            log.debug("updateNewsItem: hide images scroll")
        }
        imagesScroll.hidden = !(newsImages.count > 0)

        if (!compact) {
            textToImage.active = newsImages.count > 0
        }
    }
    
    func reloadDetails(sender: AnyObject) {
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        updateNewsItem(nil)
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
}
