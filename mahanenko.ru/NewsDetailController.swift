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
    let sizer = Sizer.sharedInstance()
    
    @IBOutlet weak var newsDate: NewsDateLabel!
    @IBOutlet weak var newsText: UITextView!
    @IBOutlet weak var newsScroll: UIScrollView!
    @IBOutlet weak var textToImage: NSLayoutConstraint!
    
    let NEWS_FONT = UIFont(name: "Helvetica Neue", size: 16)!
    
    var news: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsScroll.backgroundColor = UIColor.blackColor()
        newsText.textContainerInset = view.layoutMargins
    }
    
    override func viewWillAppear(animated: Bool) {
        self.configure()
    }
    
    func configure(){
        log.notice("configure")
        if let news = self.news {
            newsDate.text = news.dateStringShort
            if news.text == nil {
                newsText.text = "Loading..."
                news.fetchFull({ (error) -> Void in
                    if error != nil {
                        self.log.error("fetchFull error: \(error)")
                    }
                    
                    dispatch_async(dispatch_get_main_queue()){
                        self.updateNewsItem()
                    }
                })
            } else {
                self.updateNewsItem()
            }
        }
    }
    
    func updateNewsItem(){
        log.notice("updateNewsItem")
        guard let news = self.news else {
            return
        }
        
        newsText.attributedText = news.text?.attributedStringWith(NEWS_FONT)
        
        var width: CGFloat = 0
        let height: CGFloat = newsScroll.frame.size.height
        
        if let urls = news.imageUrls {
            log.notice("updateNewsItem: fetch images")
            for (index, _) in urls.enumerate() {
                let imageView = UIImageView(image: nil)
                news.fetchImage(index){ image in
                    self.log.notice("updateNewsItem: image fetched, \(index)")
                    imageView.image = image
                    let size = self.sizer.getScale(image.size, byHeight: height)
                    imageView.frame.size = size
                    imageView.frame.origin.x = width
                    imageView.frame.origin.y = 0
                    width += imageView.frame.width + 5
                    dispatch_async(dispatch_get_main_queue()){
                        self.newsScroll.addSubview(imageView)
                        self.newsScroll.contentSize = CGSize(width: width-5, height: height)
                    }
                }
            }
        
            textToImage.active = true
            newsScroll.hidden = false
        } else {
            log.notice("updateNewsItem: hide images scroll")
            textToImage.active = false
            newsScroll.hidden = true
        }
    }
}
