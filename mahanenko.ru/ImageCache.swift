//
//  File.swift
//  FavoriteActors
//
//  Created by Jason on 1/31/15.
//  Upgraded by norlin on 17/02/2016
//  Copyright (c) 2015 Udacity. All rights reserved.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class ImageCache {
    let log = Log(id: "ImageCache")
    
    private var inMemoryCache = NSCache()
    
    func imageWithIdentifier(identifier: String?) -> UIImage? {
        if identifier == nil || identifier! == "" {
            return nil
        }

        let path = pathForIdentifier(identifier!)
        
        if let image = inMemoryCache.objectForKey(path) as? UIImage {
            return image
        }
        
        if let data = NSData(contentsOfFile: path) {
            return UIImage(data: data)
        }
        
        return nil
    }
    
    func storeImage(image: UIImage?, withIdentifier identifier: String) {
        let path = pathForIdentifier(identifier)
        
        if image == nil {
            inMemoryCache.removeObjectForKey(path)
            
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            } catch {
                log.error("storeImage: remove error \(error)")
            }
            
            return
        }
        
        inMemoryCache.setObject(image!, forKey: path)
        
        let data = UIImagePNGRepresentation(image!)!
        var options = NSDataWritingOptions()
        options.insert(.DataWritingAtomic)
        do {
            try data.writeToFile(path, options: options)
        } catch {
            log.error("storeImage: save error \(error)")
        }
    }
    
    func pathForIdentifier(identifier: String) -> String {
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let escapedId = identifier.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(escapedId!)
        
        return fullURL.path!
    }
}