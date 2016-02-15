//
//  NewsDetailController.swift
//  mahanenko.ru
//
//  Created by norlin on 18/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class NewsDetailController: UIViewController {
    let log = Log(id: "NewsDetailController")
    
    @IBOutlet weak var newsDate: NewsDateLabel!
    @IBOutlet weak var newsText: UITextView!
    @IBOutlet weak var imagesScroll: UIScrollView!
    @IBOutlet weak var textToImage: NSLayoutConstraint!
    @IBOutlet weak var loader: Loader!
    
    let imagesAspect:CGFloat = 184 / 375
    
    var news: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesScroll.backgroundColor = UIColor.blackColor()
        newsText.textContainerInset = view.layoutMargins
        view.bringSubviewToFront(loader)
        
        self.configure()
    }
    
    func configure(){
        log.notice("configure")
        if let news = self.news {
            newsDate.text = news.dateStringShort
            if !news.isFull {
                newsText.hidden = true
                loader.startAnimating()
                news.fetchFull({ (error) -> Void in
                    if error != nil {
                        self.log.error("fetchFull error: \(error)")
                    }
                    
                    dispatch_async(dispatch_get_main_queue()){
                        self.updateNewsItem()
                        self.newsText.hidden = false
                        self.loader.stopAnimating()
                    }
                })
            } else {
                self.updateNewsItem()
            }
        } else {
            log.warning("No news item found!")
        }
    }
    
    func updateNewsItem(){
        log.notice("updateNewsItem")
        guard let news = self.news else {
            return
        }
        
        newsText.text = news.text?.string
        
        if let urls = news.imageUrls {
            log.debug("updateNewsItem: fetch images")
            let width = view.frame.width
            let height = width * imagesAspect
            let imageFrame = CGSize(width: width, height: height)
            imagesScroll.contentSize = CGSize(width: CGFloat(urls.count) * width, height: height)
            
            for (index, _) in urls.enumerate() {
                let imageView = UIImageView()
                imageView.hidden = true
                imageView.contentMode = .ScaleAspectFill
                imageView.frame = CGRect(origin: CGPoint(x: CGFloat(index) * width, y: 0), size: imageFrame)
                imagesScroll.addSubview(imageView)
                let loader = Loader(activityIndicatorStyle: .Gray)
                loader.center = imageView.center
                imagesScroll.addSubview(loader)
                loader.startAnimating()
                
                news.fetchImage(index){ image in
                    dispatch_async(dispatch_get_main_queue()){
                        imageView.image = image
                        imageView.hidden = false
                        loader.stopAnimating()
                    }
                }
            }
        
            textToImage.active = true
            imagesScroll.hidden = false
        } else {
            log.debug("updateNewsItem: hide images scroll")
            textToImage.active = false
            imagesScroll.hidden = true
        }
    }
}
