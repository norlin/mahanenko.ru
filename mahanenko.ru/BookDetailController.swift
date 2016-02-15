//
//  BookDetailController.swift
//  mahanenko.ru
//
//  Created by norlin on 15/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class BookDetailController: UIViewController {
    let log = Log(id: "BookDetailController")
    
    let imagesAspect:CGFloat = 184 / 375
    
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
    }
    
    func configure(){
        log.notice("configure")
    }
}