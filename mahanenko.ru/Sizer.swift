//
//  Sizer.swift
//  mahanenko.ru
//
//  Created by norlin on 02/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class Sizer {
    func getScale(size: CGSize, byHeight height: CGFloat) -> CGSize {
        var result = CGSize()
        result.height = height
        
        let scale = height / size.height
        result.width = size.width * scale
        
        return result
    }
    
    func getScale(size: CGSize, byWidth width: CGFloat) -> CGSize {
        var result = CGSize()
        result.width = width
        
        let scale = width / size.width
        result.height = size.height * scale
        
        return result
    }

    class func sharedInstance() -> Sizer {
        struct Singleton {
            static var sharedInstance = Sizer()
        }
        
        return Singleton.sharedInstance
    }

}