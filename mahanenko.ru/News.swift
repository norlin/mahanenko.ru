//
//  News.swift
//  mahanenko.ru
//
//  Created by norlin on 18/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

struct News {
    let text: String
    let images: [UIImage]
    let date: String
    let type: NewsFilterType
}
    
enum NewsFilterType {
    case All
    case Shaman
    case Galaktiona
}