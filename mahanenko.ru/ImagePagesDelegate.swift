//
//  ImagePagesDelegate.swift
//  mahanenko.ru
//
//  Created by norlin on 08/03/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class ImagePagesDelegate: UIViewController, UIPageViewControllerDataSource {
    let log = Log(id: "ImagePagesDelegate")
    
    var imageMode: UIViewContentMode!
    
    var images: [Image]! {
        didSet {
            if self.images.count == 0 {
                imageViews = nil
                return
            }
            
            self.updateImages()
        }
    }
    var imageViews: [UIViewController]?
    
    func updateImages(){
        guard let images = self.images else {
            log.warning("No images found!")
            return
        }
        
        var views = [UIViewController]()
        guard let storyboard = self.parentViewController?.storyboard else {
            log.error("no storyboard found")
            self.imageViews = nil
            return
        }
        
        for image in images {
            if let imageViewController = storyboard.instantiateViewControllerWithIdentifier("ImageView") as? ImageViewController {
            
                imageViewController.imageMode = imageMode
                imageViewController.image = image
                views.append(imageViewController)
            }
        }
        
        if views.count == 0 {
            self.imageViews = nil
            return
        }
        self.imageViews = views
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let views = imageViews else {
            return nil
        }
        guard let index = views.indexOf(viewController) else {
            return nil
        }
        
        let indexNum = index as Int
        
        if indexNum > 0 {
            return views[indexNum - 1]
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let views = imageViews else {
            return nil
        }
        guard let index = views.indexOf(viewController) else {
            return nil
        }
        
        let indexNum = index as Int
        let lastIndex = views.count - 1
        
        if indexNum < lastIndex {
            return views[indexNum + 1]
        }
        
        return nil
    }
}

class ImagePagesControlDelegate:ImagePagesDelegate {
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        if let count = imageViews?.count {
            log.debug("count \(count) views")
            return count
        }
        
        log.debug("count fail 0 views")
        return 0
    }
}