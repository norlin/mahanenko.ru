//
//  RefreshControl.swift
//  mahanenko.ru
//
//  Created by norlin on 11/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class RefreshControl: UIRefreshControl {
    let log = Log(id: "RefreshControl")
    
    override func beginRefreshing(){
        log.notice("beginRefreshing")
        super.beginRefreshing()
    }
    
    override func endRefreshing(){
        log.notice("endRefreshing")
        super.endRefreshing()
    }
}
