//
//  TableView.swift
//  mahanenko.ru
//
//  Created by norlin on 18/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class TableView: UITableView {
    let bgPattern = UIImage(named: "Background")!
    var refreshControl: UIRefreshControl? {
        didSet {
            if (refreshControl != nil){
                self.addSubview(refreshControl!)
            }
        }
    }

    func configure(){
        let bgView = UIView()
        backgroundView = bgView
        bgView.backgroundColor = UIColor(patternImage: self.bgPattern)
        self.sendSubviewToBack(backgroundView!)
        
        separatorStyle = .None
        sectionFooterHeight = 15
        sectionHeaderHeight = 0
        
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
}
