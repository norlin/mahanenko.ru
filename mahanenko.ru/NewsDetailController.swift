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
    @IBOutlet weak var textToImage: NSLayoutConstraint!
    @IBOutlet weak var textHeight: NSLayoutConstraint?
    @IBOutlet weak var loader: Loader!
    @IBOutlet weak var imagesContainer: UIView!
    
    var dataSource:ImagePagesDelegate!
    var pageController: UIPageViewController!
    var reloadButton: UIBarButtonItem!
    
    var newsId: NSManagedObjectID? {
        didSet {
            if let id = newsId {
                self.news = self.sharedContext.objectWithID(id) as? News
            }
        }
    }
    var news: News?
    var viewer: ImagePagesController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsText.textContainerInset = view.layoutMargins
        view.bringSubviewToFront(loader)
        
        reloadButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(reloadDetails(_:)))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showImages))
        imagesContainer.addGestureRecognizer(tap)
        
        dataSource = ImagePagesDelegate()
        dataSource.imageMode = UIViewContentMode.ScaleAspectFill
        addChildViewController(dataSource)
    
        pageController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        
        addChildViewController(pageController)
        imagesContainer.addSubview(pageController.view)
        
        pageController.view.frame = imagesContainer.bounds
        pageController.didMoveToParentViewController(self)
        pageController.dataSource = dataSource
        
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
            dataSource.images = news.images
        } else if let preview = news.previewImage {
            dataSource.images = [preview]
        } else {
            dataSource.images = []
        }
        
        viewer = ImagePagesController.makeViewer(self, images: dataSource.images)

        imagesContainer.hidden = dataSource.images.count == 0
        textToImage.active = dataSource.images.count > 0
        
        guard let views = dataSource.imageViews else {
            return
        }
        
        pageController.setViewControllers([views[0]], direction: .Forward, animated: true) { done in
            if done {
                self.log.debug("views are set")
            } else {
                self.log.error("can't set view controllers")
            }
        }
    }
    
    func reloadDetails(sender: AnyObject) {
        configure()
    }
    
    func showImages(){
        guard let viewer = self.viewer else {
            return
        }
        
        self.presentViewController(viewer, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imagesContainer.frame.size.width = self.view.frame.width
        
        newsText.sizeToFit()
        if let height = textHeight {
            height.constant = newsText.contentSize.height
        }
        newsText.layoutIfNeeded()
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
}
