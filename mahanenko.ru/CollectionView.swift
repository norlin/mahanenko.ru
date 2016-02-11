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
    var log:Log { return Log(id: "CollectionView") }
    let bgPattern = UIImage(named: "Background")!
    
    private func configure() {
        log.notice("configure")
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
    override var log:Log { return Log(id: "RefreshCollectionView") }
    var refreshControl: UIRefreshControl? {
        didSet {
            if (refreshControl != nil){
                self.addSubview(refreshControl!)
            }
        }
    }
    var loader: Loader? {
        didSet {
            if (loader != nil){
                self.addSubview(loader!)
            }
        }
    }

    override private func configure() {
        log.notice("configure")
        super.configure()
        addRefreshControl()
    }
    
    func addRefreshControl(){
        log.notice("addRefreshControl")
        refreshControl = RefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        loader = Loader(activityIndicatorStyle: .WhiteLarge)
        loader!.frame = self.frame
    }
}
