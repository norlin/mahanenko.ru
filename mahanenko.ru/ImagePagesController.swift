//
//  ImagePagesController.swift
//  mahanenko.ru
//
//  Created by norlin on 07/03/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class ImagePagesController: UIViewController {
    let log = Log(id: "ImagePagesController")
    
    var pageController: UIPageViewController!
    var dataSource: ImagePagesDelegate!
    @IBOutlet weak var dismissButton: UIButton!
    
    var images: [Image]?
    var imageMode: UIViewContentMode!
    
    override func viewDidLoad() {
        dataSource = ImagePagesControlDelegate()
        dataSource.imageMode = imageMode
        addChildViewController(dataSource)
        
    
        pageController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        
        addChildViewController(pageController)
        view.addSubview(pageController.view)
        
        pageController.didMoveToParentViewController(self)
        pageController.dataSource = dataSource
        
        view.bringSubviewToFront(dismissButton)
        
        configure()
    }
    
    func configure(){
        dataSource.images = images
        pageController.view.frame = view.bounds
        
        guard let views = dataSource.imageViews else {
            return
        }
        
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
    
    class func makeViewer(sender: UIViewController, images: [Image], imageMode: UIViewContentMode = .ScaleAspectFit) -> ImagePagesController? {
        if let imagePagesController = sender.storyboard?.instantiateViewControllerWithIdentifier("ImagePagesController") as? ImagePagesController {
        
            imagePagesController.imageMode = imageMode
            imagePagesController.images = images
            imagePagesController.modalPresentationStyle = .OverFullScreen
            
            return imagePagesController
        } else {
            print("failed to instantiate page controller")
            return nil
        }
    }
}