//
//  Items.swift
//  mahanenko.ru
//
//  Created by norlin on 07/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import Foundation

class FilterableItem {
    func filter(type: String) -> Bool {
        return true
    }
    
    var types: [String] { return [] }
}