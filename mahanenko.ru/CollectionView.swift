//
//  CollectionView.swift
//  mahanenko.ru
//
//  Created by norlin on 10/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

//
//  TableView.swift
//  mahanenko.ru
//
//  Created by norlin on 18/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class CollectionView: UICollectionView {
    let bgPattern = UIImage(named: "Background")!
    
    private func configure() {
        let bgView = UIView()
        backgroundView = bgView
        bgView.backgroundColor = UIColor(patternImage: self.bgPattern)
        self.sendSubviewToBack(backgroundView!)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
}

class RefreshCollectionView: CollectionView {
    var refreshControl: UIRefreshControl? {
        didSet {
            if (refreshControl != nil){
                self.addSubview(refreshControl!)
            }
        }
    }

    override private func configure() {
        super.configure()
        addRefreshControl()
    }
    
    func addRefreshControl(){
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
    }
}
