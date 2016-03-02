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
    var images: [Image]! {
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
                loader = Loader(activityIndicatorStyle: .Gray)
                self.addSubview(loader)
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
    let log = Log(id: "ImageViewController")
    var images: [Image]!
    
    @IBOutlet weak var imagesScroll: ImageScroll!
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        log.notice("viewDidLoad")
        
        view.backgroundColor = UIColor.clearColor()
        imagesScroll.backgroundColor = UIColor.clearColor()
        view.bringSubviewToFront(dismissButton)
        
        imagesScroll.imageMode = .ScaleAspectFit
        imagesScroll.images = images
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imagesScroll.updateImages()
    }
    
    func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dismissButton(sender: AnyObject) {
        dismiss()
    }
    
    class func showViewer(sender: UIViewController, images: [Image]) {
        if let imageViewController = sender.storyboard?.instantiateViewControllerWithIdentifier("ImageView") as? ImageViewController {
            imageViewController.images = images
            sender.presentViewController(imageViewController, animated: true, completion: nil)
        }
    }
}
