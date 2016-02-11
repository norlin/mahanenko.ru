//
//  Loader.swift
//  mahanenko.ru
//
//  Created by norlin on 11/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class Loader: UIActivityIndicatorView {
    override init(activityIndicatorStyle style: UIActivityIndicatorViewStyle) {
        super.init(activityIndicatorStyle: style)
        configure()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure(){
        self.hidesWhenStopped = true
        self.color = UIColor.blackColor()
    }
}