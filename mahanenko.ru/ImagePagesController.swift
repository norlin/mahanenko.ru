//
//  ImagePagesController.swift
//  mahanenko.ru
//
//  Created by norlin on 07/03/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class ImagePagesController: UIViewController, UIPageViewControllerDataSource {
    let log = Log(id: "ImagePagesController")
    
    var pageController: UIPageViewController!
    @IBOutlet weak var dismissButton: UIButton!
    
    var images: [Image]?
    var imageViews: [UIViewController]?
    
    override func viewDidLoad() {
        pageController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        
        addChildViewController(pageController)
        view.addSubview(pageController.view)
        pageController.view.frame = view.bounds
        pageController.didMoveToParentViewController(self)
        pageController.dataSource = self
        
        view.bringSubviewToFront(dismissButton)
        
        updateImages()
    }
    
    func updateImages(){
        guard let images = self.images else {
            log.warning("No images found!")
            return
        }
        
        var views = [UIViewController]()
        for image in images {
            if let imageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageView") as? ImageViewController {
            
                imageViewController.image = image
                views.append(imageViewController)
            }
        }
        imageViews = views
        
        pageController.setViewControllers([views[0]], direction: .Forward, animated: true) { done in
            if done {
                self.log.debug("views are set")
            }   else {
                self.log.error("can't set view controllers")
            }
        }
    }
        
    func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dismissButton(sender: AnyObject) {
        dismiss()
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
        
        viewController
        
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
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        if let count = imageViews?.count {
            log.debug("count \(count) views")
            return count
        }
        
        log.debug("count fail 0 views")
        return 0
    }
    
    class func showViewer(sender: UIViewController, images: [Image]) {
        if let imagePagesController = sender.storyboard?.instantiateViewControllerWithIdentifier("ImagePagesController") as? ImagePagesController {
            imagePagesController.images = images
            sender.presentViewController(imagePagesController, animated: true, completion: nil)
        } else {
            print("failed to instantiate page controller")
        }
    }
}
