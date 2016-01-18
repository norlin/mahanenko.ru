//
//  NewsDetailController.swift
//  mahanenko.ru
//
//  Created by norlin on 18/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class NewsDetailController: UIViewController {
    
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var newsScroll: UIScrollView!
    
    var news: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.configure()
    }
    
    func configure(){
        if let news = self.news {
            newsText.text = news.text
            newsText.preferredMaxLayoutWidth = newsText.frame.width
            
            for (i, image) in news.images.enumerate() {
                let imageView = UIImageView(image: image)
                imageView.frame.size = newsScroll.frame.size
                newsScroll.addSubview(imageView)
                imageView.frame.origin.x = CGFloat(i) * imageView.frame.width
                imageView.frame.origin.y = 0
            }
        }
    }
}
