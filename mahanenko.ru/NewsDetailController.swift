//
//  NewsDetailController.swift
//  mahanenko.ru
//
//  Created by norlin on 18/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class NewsDetailController: UIViewController {
    
    @IBOutlet weak var newsDate: NewsDateLabel!
    @IBOutlet weak var newsText: UITextView!
    @IBOutlet weak var newsScroll: UIScrollView!
    @IBOutlet weak var textToImage: NSLayoutConstraint!
    
    var news: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsScroll.backgroundColor = UIColor.blackColor()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.configure()
    }
    
    func getImageSize(size: CGSize, heigth: CGFloat) -> CGSize {
        var result = CGSize()
        result.height = heigth
        
        let scale = heigth / size.height
        result.width = size.width * scale
        
        return result
    }
    
    func configure(){
        if let news = self.news {
            newsDate.text = news.date
            newsText.text = news.text
            
            var width: CGFloat = 0
            let height: CGFloat = newsScroll.frame.size.height
            
            if let images = news.images {
                textToImage.active = true
                for (image) in images {
                    let imageView = UIImageView(image: image)
                    imageView.frame.size = getImageSize(imageView.frame.size, heigth: height)
                    imageView.frame.origin.x = width
                    imageView.frame.origin.y = 0
                    newsScroll.addSubview(imageView)
                    width += imageView.frame.width + 5
                }
                width -= 5
            } else {
                newsScroll.hidden = true
                textToImage.active = false
            }
            
            newsScroll.contentSize = CGSize(width: width, height: height)
        }
    }
}
