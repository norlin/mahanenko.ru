//
//  ItemsCollectionLayout.swift
//  mahanenko.ru
//
//  Created by norlin on 11/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class ItemsCollectionFlowLayout: UICollectionViewFlowLayout {
    let interlineSpacing:CGFloat = 10

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attrs = super.layoutAttributesForElementsInRect(rect) {
            var newAttrs = [UICollectionViewLayoutAttributes]()
            for attr in attrs {
                let newAttr = attr.copy() as! UICollectionViewLayoutAttributes
                if newAttr.representedElementKind == nil {
                    newAttr.frame = self.layoutAttributesForItemAtIndexPath(attr.indexPath)!.frame
                }
                newAttrs.append(newAttr)
            }
            
            return newAttrs
        }
        
        return nil
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.layoutAttributesForTopAlignmentForItemAtIndexPath(indexPath)
    }
    
    func layoutAttributesForTopAlignmentForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        if let attrs = super.layoutAttributesForItemAtIndexPath(indexPath)?.copy() as? UICollectionViewLayoutAttributes {
            if (attrs.frame.origin.y <= self.sectionInset.top) {
                return attrs
            }
            
            var frame = attrs.frame
            
            if (indexPath.item == 0) {
                frame.origin.y = self.sectionInset.top
            } else {
                let previousIndexPath = NSIndexPath(forItem: indexPath.item-1, inSection: indexPath.section)
                let previousAttributes = self.layoutAttributesForItemAtIndexPath(previousIndexPath)!
                
                if (attrs.frame.origin.x > previousAttributes.frame.origin.x) {
                    frame.origin.y = previousAttributes.frame.origin.y
                } else {
                    var maxY:CGFloat!
                    if (indexPath.item > 1) {
                        let prev2IndexPath = NSIndexPath(forItem: indexPath.item-2, inSection: indexPath.section)
                        let prev2Attr = self.layoutAttributesForItemAtIndexPath(prev2IndexPath)!
                        
                        maxY = max(CGRectGetMaxY(previousAttributes.frame), CGRectGetMaxY(prev2Attr.frame))
                    } else {
                        maxY = CGRectGetMaxY(previousAttributes.frame)
                    }
                    frame.origin.y = maxY + self.minimumInteritemSpacing + interlineSpacing
                }
            }
            
            attrs.frame = frame
            
            return attrs
        }
        
        print("nil!")
        return nil
    }
}
