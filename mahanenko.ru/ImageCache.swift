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
    
    // MARK: - Retreiving images
    
    func escapeId(id: String) -> String? {
        return id.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())
    }
    
    func imageWithIdentifier(identifier: String?) -> UIImage? {
        
        // If the identifier is nil, or empty, return nil
        if identifier == nil || identifier! == "" {
            log.debug("imageWithIdentifier: nil")
            return nil
        }
        
        guard let identifier = identifier else {
            return nil
        }
        
        guard let escapedId = escapeId(identifier) else {
            return nil
        }
        let path = pathForIdentifier(escapedId)
        
        // First try the memory cache
        if let image = inMemoryCache.objectForKey(path) as? UIImage {
            log.debug("imageWithIdentifier: cache \(path)")
            return image
        }
        
        // Next Try the hard drive
        if let data = NSData(contentsOfFile: path) {
            log.debug("imageWithIdentifier: file \(path)")
            return UIImage(data: data)
        }
        
        log.warning("imageWithIdentifier: no data found \(identifier)")
        
        return nil
    }
    
    // MARK: - Saving images
    
    func storeImage(image: UIImage?, withIdentifier identifier: String) {
        guard let escapedId = escapeId(identifier) else {
            return
        }
        let path = pathForIdentifier(escapedId)
        
        // If the image is nil, remove images from the cache
        if image == nil {
            inMemoryCache.removeObjectForKey(path)
            
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            } catch {
                log.error("storeImage: remove error \(error)")
            }
            
            return
        }
        
        // Otherwise, keep the image in memory
        inMemoryCache.setObject(image!, forKey: path)
        
        // And in documents directory
        let data = UIImagePNGRepresentation(image!)!
        var options = NSDataWritingOptions()
        options.insert(.DataWritingAtomic)
        do {
            try data.writeToFile(path, options: options)
        } catch {
            log.error("storeImage: save error \(error)")
        }
    }
    
    // MARK: - Helper
    
    func pathForIdentifier(identifier: String) -> String {
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(identifier)
        
        return fullURL.path!
    }
}