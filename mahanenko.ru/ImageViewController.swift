//
//  ImageViewController.swift
//  mahanenko.ru
//
//  Created by norlin on 02/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var imageMode: UIViewContentMode!
    var image: Image!
    
    override func viewDidLoad() {
        imageView.contentMode = imageMode
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
