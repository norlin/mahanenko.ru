//
//  Image.swift
//  mahanenko.ru
//
//  Created by norlin on 17/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit
import CoreData

class Image: NSManagedObject {
    @NSManaged var url:String
    @NSManaged var newsInverse:News
    @NSManaged var newsPreviewInverse:News
    @NSManaged var bookInverse:Book
    @NSManaged var book3dInverse:Book
    
    var image:UIImage? {
        get {
            return SiteAPI.Caches.imageCache.imageWithIdentifier(url)
        }
        
        set {
            SiteAPI.Caches.imageCache.storeImage(newValue, withIdentifier: url)
        }
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(url: String, context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("Image", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
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
