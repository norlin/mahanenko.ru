//
//  FullScreenImage.swift
//  mahanenko.ru
//
//  Created by norlin on 02/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class ImageScroll: UIScrollView {
    var imageMode = UIViewContentMode.ScaleAspectFill
    var loaderStyle = UIActivityIndicatorViewStyle.Gray
    var images = [Image]() {
        didSet {
            if images.count == 0 {
                imageViews.removeAll()
                return
            }
            
            updateImages()
        }
    }
    var imageViews = [UIImageView]()
   
    func updateImages(){
        if images.count == 0 {
            return
        }
        
        let imageFrame = self.frame.size
        self.contentSize = CGSize(width: CGFloat(images.count) * imageFrame.width, height: imageFrame.height)
        let centerY = self.center.y
        
        if (images.count != imageViews.count) {
            for imageView in imageViews {
                imageView.removeFromSuperview()
            }
            imageViews.removeAll()
        }

        for (index, image) in images.enumerate() {
            let imageView:UIImageView
            let loader: Loader
            
            if imageViews.count > index {
                imageView = imageViews[index]
            } else {
                imageView = UIImageView()
                imageView.contentMode = imageMode
                imageViews.append(imageView)
                self.addSubview(imageView)
            }
            if let existingLoader = imageView.subviews.filter({ $0.isKindOfClass(Loader) }).first as? Loader {
                loader = existingLoader
            } else {
                loader = Loader(activityIndicatorStyle: loaderStyle)
                imageView.addSubview(loader)
            }
            
            imageView.frame = CGRect(origin: CGPoint(x: CGFloat(index) * imageFrame.width, y: 0), size: imageFrame)
            imageView.center.y = centerY
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
    }
    
}

class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var image: Image!
    
    override func viewDidLoad() {
        loader.startAnimating()
        image.fetch(){ (error, image) in
            if (error){
                self.imageView.contentMode = UIViewContentMode.Center
            }
            dispatch_async(dispatch_get_main_queue()){
                self.imageView.image = image
                self.loader.stopAnimating()
            }
        }
    }
}
