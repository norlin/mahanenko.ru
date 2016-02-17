//
//  Image.swift
//  mahanenko.ru
//
//  Created by norlin on 17/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class Image {
    let url:String
    var image:UIImage?
    
    init(url: String) {
        self.url = url
    }
    
    func fetch(completion: (image: UIImage)->Void){
        if let image = self.image {
            completion(image: image)
            return
        }
        let imageURL = NSURL(string: self.url)
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        dispatch_async(backgroundQueue) {
            if let imageData = NSData(contentsOfURL: imageURL!) {
                if let image = UIImage(data: imageData) {
                    self.image = image
                    dispatch_async(dispatch_get_main_queue()){
                        completion(image: image)
                    }
                } else {
                    // TODO: handle parsing error
                }
            } else {
                // TODO: handle fetching error
            }
        }
    }
}
